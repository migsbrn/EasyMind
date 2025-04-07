import React from "react";
import { BrowserRouter as Router, Route, Routes } from "react-router-dom"; //npm install react-router-dom
import Login from "./AdminLogin";
import Dashboard from "./Dashboard";
import ManageTeachers from "./ManageTeachers";
import UsersList from "./UsersList";
import SystemLogs from "./SystemLogs";
import Archives from "./Archives";

function App() {
  return (
    <Router>
      <Routes>
      <Route path="/" element={<Login />} />
        <Route path="/dashboard" element={<Dashboard />} />
        <Route path="/manage-teachers" element={<ManageTeachers />} />
        <Route path="/users-list" element={<UsersList />} />
        <Route path="/system-logs" element={<SystemLogs />} />
        <Route path="/archives" element={<Archives />} />
      </Routes>
    </Router>
  );
}

export default App;