import React, { useState, useEffect } from "react";
import { useNavigate } from "react-router-dom";
import { 
  getFirestore, 
  collection, 
  onSnapshot, 
  query, 
  orderBy 
} from "firebase/firestore";
import { db } from "../firebase.js"; // Adjust path as needed
import { FaSearch } from "react-icons/fa";
import "../style/SystemLogs.css";

const SystemLogs = () => {
  const navigate = useNavigate();
  const [logs, setLogs] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [filters, setFilters] = useState({
    search: '',
    user: '' // Filter by the user who performed the action
  });

  // Fetch logs from Firestore with real-time updates
  useEffect(() => {
    const dbInstance = getFirestore();
    const logsCollection = collection(dbInstance, "systemLogs");
    
    // Order logs by timestamp descending (newest first)
    const logsQuery = query(logsCollection, orderBy("timestamp", "desc"));

    const unsubscribe = onSnapshot(
      logsQuery,
      (snapshot) => {
        const logsList = snapshot.docs.map(doc => ({
          id: doc.id,
          name: doc.data().name || "Unknown", // Name of the person affected
          date: doc.data().date || "N/A",
          time: doc.data().time || "N/A",
          action: doc.data().action || "No action specified",
          user: doc.data().user || "Unknown", // User who performed the action
          timestamp: doc.data().timestamp || 0 // For sorting
        }));
        setLogs(logsList);
        setLoading(false);
      },
      (error) => {
        console.error("Error fetching system logs:", error);
        setError("Failed to load system logs. Please try again.");
        setLoading(false);
      }
    );

    return () => unsubscribe();
  }, []);

  // Handle filter changes
  const handleFilterChange = (field, value) => {
    setFilters(prev => ({ ...prev, [field]: value }));
  };

  // Filter logs
  const filteredLogs = logs.filter(log => {
    return (
      (log.name.toLowerCase().includes(filters.search.toLowerCase()) ||
       log.action.toLowerCase().includes(filters.search.toLowerCase())) &&
      (filters.user ? log.user.toLowerCase() === filters.user.toLowerCase() : true)
    );
  });

  if (loading) {
    return <div className="loading">Loading system logs...</div>;
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
          <li onClick={() => navigate("/users-list")}>Users List</li>
          <li className="active" onClick={() => navigate("/system-logs")}>System Logs</li>
          <li onClick={() => navigate("/archives")}>Archives</li>
        </ul>
      </div>

      <div className="sl-main-content">
        <h1 className="title">System Logs</h1>

        {/* Filters */}
        <div className="sl-filters">
          <div className="sl-search-container">
            <input
              type="text"
              placeholder="Search.."
              value={filters.search}
              onChange={(e) => handleFilterChange('search', e.target.value)}
              className="sl-filter-input"
            />
            <FaSearch className="sl-search-icon" />
          </div>
          <select
            value={filters.user}
            onChange={(e) => handleFilterChange('user', e.target.value)}
            className="sl-filter-input"
          >
            <option value="">All Users</option>
            <option value="admin">Admin</option>
            <option value="teacher">Teacher</option>
            <option value="student">Student</option>
          </select>
        </div>

        {/* Logs Table */}
        <div className="table-container">
          <table>
            <thead>
              <tr>
                <th>Name</th>
                <th>Date</th>
                <th>Time</th>
                <th>Action</th>
                <th>User</th>
              </tr>
            </thead>
            <tbody>
              {filteredLogs.map((log) => (
                <tr key={log.id}>
                  <td>{log.name}</td>
                  <td>{log.date}</td>
                  <td>{log.time}</td>
                  <td>{log.action}</td>
                  <td>{log.user}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
};

export default SystemLogs;