import React, { useState, useEffect } from 'react';
import { useNavigate } from "react-router-dom";
import { db } from '../firebase';
import { collection, onSnapshot } from 'firebase/firestore';
import { FaSearch } from "react-icons/fa";
import '../style/Archives.css';

const Archives = () => {
  const navigate = useNavigate();
  const [archivedTeachers, setArchivedTeachers] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [filters, setFilters] = useState({
    search: '',
    type: '',
    archivedBy: ''
  });

  useEffect(() => {
    const archivesCollection = collection(db, 'archives');

    const unsubscribe = onSnapshot(
      archivesCollection,
      (snapshot) => {
        const archivedList = snapshot.docs.map(doc => ({
          id: doc.id,
          ...doc.data(),
        }));
        setArchivedTeachers(archivedList);
        setLoading(false);
      },
      (error) => {
        console.error("Error listening to archives:", error);
        setError("Failed to load archives. Please try again.");
        setLoading(false);
      }
    );

    return () => unsubscribe();
  }, []);

  // Filter archives
  const filteredTeachers = archivedTeachers.filter(teacher => {
    return (
      (teacher.name.toLowerCase().includes(filters.search.toLowerCase())) &&
      (filters.type ? teacher.type.toLowerCase() === filters.type.toLowerCase() : true) &&
      (filters.archivedBy ? teacher.archivedBy.toLowerCase().includes(filters.archivedBy.toLowerCase()) : true)
    );
  });

  // Handle filter changes
  const handleFilterChange = (field, value) => {
    setFilters(prev => ({ ...prev, [field]: value }));
  };

  // Format date as "YYYY-MM-DD HH:MM AM/PM"
  const formatDate = (isoString) => {
    const date = new Date(isoString);
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    const hours = date.getHours() % 12 || 12; // Convert to 12-hour format
    const minutes = String(date.getMinutes()).padStart(2, '0');
    const ampm = date.getHours() >= 12 ? 'PM' : 'AM';
    return `${year}-${month}-${day} ${hours}:${minutes}${ampm}`;
  };

  if (loading) return <div className="loading">Loading archives...</div>;
  if (error) return <div className="error">{error}</div>;

  return (
    <div className="dashboard-container">
      <div className="sidebar">
        <h2>Admin Panel</h2>
        <ul>
          <li onClick={() => navigate("/")}>Dashboard</li>
          <li onClick={() => navigate("/manage-teachers")}>Manage Teachers</li>
          <li onClick={() => navigate("/users-list")}>Users List</li>
          <li onClick={() => navigate("/system-logs")}>System Logs</li>
          <li className="active" onClick={() => navigate("/archives")}>Archives</li>
        </ul>
      </div>

      <div className="main-content">
        <h1 className="title">Archives</h1>

        {/* Filters */}
        <div className="ar-filters">
          <div className="ar-search-container">
            <input
              type="text"
              placeholder="Search by name..."
              value={filters.search}
              onChange={(e) => handleFilterChange('search', e.target.value)}
              className="ar-filter-input"
            />
            <FaSearch className="search-icon" />
          </div>
          <select
            value={filters.type}
            onChange={(e) => handleFilterChange('type', e.target.value)}
            className="ar-filter-input"
          >
            <option value="">All Types</option>
            <option value="Teacher">Teacher</option>
            <option value="Other">Other</option>
          </select>
          <input
            type="text"
            placeholder="Archived by..."
            value={filters.archivedBy}
            onChange={(e) => handleFilterChange('archivedBy', e.target.value)}
            className="ar-filter-input"
          />
        </div>

        {/* Archives Table */}
        <div className="table-container">
          <table>
            <thead>
              <tr>
                <th>Name</th>
                <th>Type</th>
                <th>Date Archived</th>
                <th>Archived By</th>
              </tr>
            </thead>
            <tbody>
              {filteredTeachers.map(teacher => (
                <tr key={teacher.id}>
                  <td>{teacher.name}</td>
                  <td>{teacher.type || 'Teacher'}</td>
                  <td>{formatDate(teacher.archivedAt)}</td>
                  <td>{teacher.archivedBy || 'Admin'}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
};

export default Archives;