import React, { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import { PieChart, Pie, Cell, LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, Legend, ResponsiveContainer, Area } from "recharts";
import { db } from "/src/firebase.js";
import { collection, getDocs, query, where } from "firebase/firestore";
import "../style/Dashboard.css";

const Dashboard = () => {
  const navigate = useNavigate();

  const [teachersCount, setTeachersCount] = useState(0);
  const [studentsCount, setStudentsCount] = useState(0);
  const [dailyActiveUsers, setDailyActiveUsers] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");

  useEffect(() => {
    const fetchData = async () => {
      try {
        setLoading(true);
        setError("");

        const teachersSnapshot = await getDocs(collection(db, "teachers"));
        setTeachersCount(teachersSnapshot.size);

        const studentsSnapshot = await getDocs(collection(db, "students"));
        setStudentsCount(studentsSnapshot.size);

        const oneWeekAgo = new Date();
        oneWeekAgo.setDate(oneWeekAgo.getDate() - 7);

        const dailyData = [];
        const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
        for (let i = 6; i >= 0; i--) {
          const day = new Date();
          day.setDate(day.getDate() - i);
          day.setHours(0, 0, 0, 0);
          const nextDay = new Date(day);
          nextDay.setDate(nextDay.getDate() + 1);
          nextDay.setHours(0, 0, 0, 0);

          const loginsQuery = query(
            collection(db, "logins"),
            where("timestamp", ">=", day),
            where("timestamp", "<", nextDay)
          );

          const loginsSnapshot = await getDocs(loginsQuery);
          const totalActiveUsers = loginsSnapshot.size;
          dailyData.push({ name: days[i], activeUsers: totalActiveUsers });
        }

        setDailyActiveUsers(dailyData);
      } catch (err) {
        console.error("Unexpected error fetching data:", err);
        setError("");
      } finally {
        setLoading(false);
      }
    };

    fetchData();
  }, []);

  const totalUsers = teachersCount + studentsCount;
  const pieData = [
    { name: `Teachers: ${teachersCount} (${totalUsers > 0 ? ((teachersCount / totalUsers) * 100).toFixed(1) : 0}%)`, value: teachersCount, color: "#4CAF50" },
    { name: `Students: ${studentsCount} (${totalUsers > 0 ? ((studentsCount / totalUsers) * 100).toFixed(1) : 0}%)`, value: studentsCount, color: "#FF9800" },
  ];

  const lineData = dailyActiveUsers.length === 0 
    ? Array.from({ length: 7 }, (_, i) => ({ name: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][i], activeUsers: 0 }))
    : dailyActiveUsers;

  return (
    <div className="dashboard-container">
      <div className="sidebar">
        <h2>Admin Panel</h2>
        <ul>
          <li className="active" onClick={() => navigate("/")}>Dashboard</li>
          <li onClick={() => navigate("/manage-teachers")}>Manage Teachers</li>
          <li onClick={() => navigate("/users-list")}>Users List</li>
          <li onClick={() => navigate("/system-logs")}>System Logs</li>
          <li onClick={() => navigate("/archives")}>Archives</li>
        </ul>
      </div>

      <div className="main-content">
        <h1 className="title">Admin Dashboard</h1>

        {loading ? (
          <p>Loading data...</p>
        ) : (
          <div className="charts-container">
            <div className="chart-container">
              <div className="chart">
                <h3>Total Teachers vs. Students</h3>
                <ResponsiveContainer width="100%" height={300}>
                  <PieChart>
                    <Pie data={pieData} dataKey="value" outerRadius={100}>
                      {pieData.map((entry, index) => (
                        <Cell key={`cell-${index}`} fill={entry.color} />
                      ))}
                    </Pie>
                    <Tooltip />
                    <Legend />
                  </PieChart>
                </ResponsiveContainer>
              </div>
            </div>

            <div className="line-chart-container">
              <div className="line-chart">
                <h3>Daily Active Users (Last 7 Days)</h3>
                <ResponsiveContainer width="100%" height={300}>
                  <LineChart data={lineData}>
                    <XAxis dataKey="name" />
                    <YAxis />
                    <CartesianGrid stroke="#ccc" />
                    <Tooltip />
                    <Area type="monotone" dataKey="activeUsers" fill="#BBDEFB" fillOpacity={0.3} stroke="#2196F3" strokeWidth={2} />
                    <Line type="monotone" dataKey="activeUsers" stroke="#2196F3" strokeWidth={2} />
                    <Legend />
                  </LineChart>
                </ResponsiveContainer>
              </div>
            </div>
          </div>
        )}
      </div>
    </div>
  );
};

export default Dashboard;