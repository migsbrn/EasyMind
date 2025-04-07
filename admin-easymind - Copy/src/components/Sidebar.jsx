import React from 'react';
import { NavLink, useLocation } from 'react-router-dom';
import '../style/Sidebar.css';

const Sidebar = () => {
  const location = useLocation();

  return (
    <div className="sidebar">
      <h2>Admin Panel</h2>
      <ul>
        <li>
          <NavLink to="/" className={location.pathname === "/" ? "active" : ""}>Dashboard</NavLink>
        </li>
        <li>
          <NavLink to="/manage-teachers" className={location.pathname === "/manage-teachers" ? "active" : ""}>Manage Teachers</NavLink>
        </li>
        <li>
          <NavLink to="/users-list" className={location.pathname === "/users-list" ? "active" : ""}>Users List</NavLink>
        </li>
        <li>
          <NavLink to="/system-logs" className={location.pathname === "/system-logs" ? "active" : ""}>System Logs</NavLink>
        </li>
        <li>
          <NavLink to="/archives" className={location.pathname === "/archives" ? "active" : ""}>Archives</NavLink>
        </li>
      </ul>
    </div>
  );
};

export default Sidebar;