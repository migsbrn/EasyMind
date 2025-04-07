import React, { useState, useEffect } from "react";
import { useNavigate } from "react-router-dom";
import { 
  getFirestore, 
  collection,  
  updateDoc, 
  doc, 
  setDoc,
  onSnapshot 
} from "firebase/firestore";
import { db } from "../firebase.js";
import "../style/ManageTeachers.css";
import { FaSearch } from "react-icons/fa";
import { IoIosArrowDropdown } from "react-icons/io";

const ManageTeachers = () => {
  const navigate = useNavigate();
  const [teachers, setTeachers] = useState([]);
  const [openDropdown, setOpenDropdown] = useState(null);
  const [modal, setModal] = useState({ show: false, action: "", teacher: null });
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [filters, setFilters] = useState({
    search: '',
    status: '',
  });

  // Fetch teachers from Firestore with real-time updates
  useEffect(() => {
    const dbInstance = getFirestore();
    const teachersCollection = collection(dbInstance, "teachers");

    const unsubscribe = onSnapshot(
      teachersCollection,
      (snapshot) => {
        const teachersList = snapshot.docs
          .filter(doc => !doc.data().isArchived)
          .map(doc => ({
            id: doc.id,
            ...doc.data()
          }));
        setTeachers(teachersList);
        setLoading(false);
      },
      (error) => {
        console.error("Error listening to teachers:", error);
        setError("Failed to load teachers. Please try again.");
        setLoading(false);
      }
    );

    return () => unsubscribe();
  }, []);

  // Toggle Dropdown
  const toggleDropdown = (id) => {
    setOpenDropdown(openDropdown === id ? null : id);
  };

  // Close dropdown when clicking outside
  useEffect(() => {
    const closeDropdown = (e) => {
      if (!e.target.closest(".dropdown-container")) {
        setOpenDropdown(null);
      }
    };
    document.addEventListener("click", closeDropdown);
    return () => document.removeEventListener("click", closeDropdown);
  }, []);

  // Show confirmation modal
  const showModal = (action, teacher) => {
    setModal({ show: true, action, teacher });
  };

  // Confirm action (Enable, Disable, Archive)
  const confirmAction = async () => {
    if (!modal.teacher) return;
    const teacherRef = doc(db, "teachers", modal.teacher.id);

    try {
      if (modal.action === "disable") {
        await updateDoc(teacherRef, { status: "disabled" });
      } else if (modal.action === "enable") {
        await updateDoc(teacherRef, { status: "active" });
      } else if (modal.action === "archive") {
        const archivedData = { 
          ...modal.teacher, 
          archivedAt: new Date().toISOString(),
          type: 'Teacher',
          archivedBy: 'Admin'
        };
        await setDoc(doc(db, "archives", modal.teacher.id), archivedData);
        await updateDoc(teacherRef, { isArchived: true });
        setTeachers(teachers.filter(t => t.id !== modal.teacher.id));
      }

      setModal({ show: false, action: "", teacher: null });
    } catch (error) {
      console.error("Error updating teacher:", error);
      setError("Failed to update teacher status. Please try again.");
    }
  };

  // Filter teachers
  const filteredTeachers = teachers.filter(teacher => {
    return (
      (teacher.name.toLowerCase().includes(filters.search.toLowerCase()) || 
       teacher.email.toLowerCase().includes(filters.search.toLowerCase())) &&
      (filters.status ? teacher.status.toLowerCase() === filters.status.toLowerCase() : true)
    );
  });

  // Handle filter changes
  const handleFilterChange = (field, value) => {
    setFilters(prev => ({ ...prev, [field]: value }));
  };

  if (loading) {
    return <div className="loading">Loading teachers...</div>;
  }

  if (error) {
    return <div className="error">{error}</div>;
  }

  return (
    <div className="dashboard-container">
      <div className="sidebar">
        <h2>Admin Panel</h2>
        <ul>
          <li onClick={() => navigate("/")}>Dashboard</li>
          <li className="active" onClick={() => navigate("/manage-teachers")}>Manage Teachers</li>
          <li onClick={() => navigate("/users-list")}>Users List</li>
          <li onClick={() => navigate("/system-logs")}>System Logs</li>
          <li onClick={() => navigate("/archives")}>Archives</li>
        </ul>
      </div>

      {/* Main Content */}
      <div className="mt-main-content">
        <h1 className="title">Manage Teachers</h1>

        {/* Filters */}
        <div className="mt-filters">
          <div className="mt-search-container">
            <input
              type="text"
              placeholder="Search..."
              value={filters.search}
              onChange={(e) => handleFilterChange('search', e.target.value)}
              className="mt-filter-input"
            />
            <FaSearch className="mt-search-icon" />
          </div>
          <select
            value={filters.status}
            onChange={(e) => handleFilterChange('status', e.target.value)}
            className="mt-filter-input"
          >
            <option value="">All Statuses</option>
            <option value="active">Active</option>
            <option value="disabled">Disabled</option>
          </select>
        </div>

        {/* Teachers Table */}
        <div className="table-container">
          <table>
            <thead>
              <tr>
                <th>Name</th>
                <th>Email</th>
                <th>Status</th>
                <th>Actions</th>
              </tr>
            </thead>
            <tbody>
              {filteredTeachers.map((teacher) => (
                <tr key={teacher.id} className={teacher.status === "disabled" ? "disabled-row" : ""}>
                  <td>{teacher.name}</td>
                  <td>{teacher.email}</td>
                  <td className={`status ${teacher.status}`}>
                    {teacher.status.charAt(0).toUpperCase() + teacher.status.slice(1)}
                  </td>
                  <td>
                    <div className="dropdown-container">
                      <button className="action-btn" onClick={() => toggleDropdown(teacher.id)}>
                        Actions <IoIosArrowDropdown />
                      </button>
                      {openDropdown === teacher.id && (
                        <div className="dropdown-menu">
                          {teacher.status === "active" ? (
                            <button onClick={() => showModal("disable", teacher)}>Disable</button>
                          ) : (
                            <button onClick={() => showModal("enable", teacher)}>Enable</button>
                          )}
                          <button onClick={() => showModal("archive", teacher)}>Archive</button>
                        </div>
                      )}
                    </div>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>

        {/* Modal Confirmation */}
        {modal.show && (
          <div className="modal-overlay">
            <div className="modal-content">
              <h2>Confirm {modal.action}</h2>
              <p>Are you sure you want to {modal.action} {modal.teacher.name}?</p>
              <div className="modal-buttons">
                <button onClick={confirmAction} className="confirm-btn">Yes</button>
                <button onClick={() => setModal({ show: false, action: "", teacher: null })} className="cancel-btn">No</button>
              </div>
            </div>
          </div>
        )}
      </div>
    </div>
  );
};

export default ManageTeachers;