import React, { useState, useEffect } from "react";
import { useNavigate } from "react-router-dom";
import { 
  getFirestore, 
  collection, 
  onSnapshot, 
  query 
} from "firebase/firestore";
import { db } from "/src/firebase.js";
import { FaSearch } from "react-icons/fa";
import "../style/UsersList.css";

const UsersList = () => {
  const navigate = useNavigate();
  const [users, setUsers] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [filters, setFilters] = useState({
    search: '',
    role: '' // Empty string means show all
  });

  // Fetch teachers and students from Firestore with real-time updates
  useEffect(() => {
    const dbInstance = getFirestore();

    const fetchUsers = () => {
      const teachersCollection = collection(dbInstance, "teachers");
      const teachersQuery = query(teachersCollection);
      const teachersUnsubscribe = onSnapshot(
        teachersQuery,
        (snapshot) => {
          const teachersList = snapshot.docs.map(doc => ({
            id: doc.id,
            name: doc.data().name || "Unnamed Teacher",
            role: (doc.data().role || "teacher").toLowerCase(),
          }));
          setUsers(prevUsers => {
            const uniqueUsers = [...prevUsers, ...teachersList].filter(
              (user, index, self) => index === self.findIndex((u) => u.id === user.id)
            );
            return uniqueUsers;
          });
          setLoading(false);
        },
        (error) => {
          console.error("Error fetching teachers:", error);
          setError("Failed to load users. Please try again.");
          setLoading(false);
        }
      );

      const studentsCollection = collection(dbInstance, "students");
      const studentsQuery = query(studentsCollection);
      const studentsUnsubscribe = onSnapshot(
        studentsQuery,
        (snapshot) => {
          const studentsList = snapshot.docs.map(doc => ({
            id: doc.id,
            name: doc.data().name || "Unnamed Student",
            role: (doc.data().role || "student").toLowerCase(),
          }));
          setUsers(prevUsers => {
            const uniqueUsers = [...prevUsers, ...studentsList].filter(
              (user, index, self) => index === self.findIndex((u) => u.id === user.id)
            );
            return uniqueUsers;
          });
          setLoading(false);
        },
        (error) => {
          console.error("Error fetching students:", error);
          setError("Failed to load users. Please try again.");
          setLoading(false);
        }
      );

      return () => {
        teachersUnsubscribe();
        studentsUnsubscribe();
      };
    };

    fetchUsers();
  }, []);

  // Handle filter changes
  const handleFilterChange = (field, value) => {
    setFilters(prev => ({ ...prev, [field]: value }));
  };

  // Filter users
  const filteredUsers = users.filter(user => {
    return (
      (user.name.toLowerCase().includes(filters.search.toLowerCase())) &&
      (filters.role ? user.role.toLowerCase() === filters.role.toLowerCase() : true)
    );
  });

  if (loading) {
    return <div className="loading">Loading users...</div>;
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
          <li onClick={() => navigate("/manage-teachers")}>Manage Teachers</li>
          <li className="active" onClick={() => navigate("/users-list")}>Users List</li>
          <li onClick={() => navigate("/system-logs")}>System Logs</li>
          <li onClick={() => navigate("/archives")}>Archives</li>
        </ul>
      </div>

      <div className="ul-main-content">
        <h1 className="title">Users List</h1>

        {/* Filters */}
        <div className="ul-filters">
          <div className="ul-search-container">
            <input
              type="text"
              placeholder="Search..."
              value={filters.search}
              onChange={(e) => handleFilterChange('search', e.target.value)}
              className="ul-filter-input"
            />
            <FaSearch className="search-icon" />
          </div>
          <select
            value={filters.role}
            onChange={(e) => handleFilterChange('role', e.target.value)}
            className="ul-filter-input"
          >
            <option value="">All Roles</option>
            <option value="teacher">Teacher</option>
            <option value="student">Student</option>
          </select>
        </div>

        {/* Table */}
        <div className="table-container">
          <table>
            <thead>
              <tr>
                <th>Name</th>
                <th>Role</th>
              </tr>
            </thead>
            <tbody>
              {filteredUsers.map((user) => (
                <tr key={user.id}>
                  <td>{user.name}</td>
                  <td>{user.role.charAt(0).toUpperCase() + user.role.slice(1)}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
};

export default UsersList;