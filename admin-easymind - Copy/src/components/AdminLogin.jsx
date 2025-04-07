import React, { useState, useEffect } from 'react';
import { auth } from '/src/firebase.js';
import { signInWithEmailAndPassword, onAuthStateChanged } from 'firebase/auth';
import { useNavigate, useLocation } from 'react-router-dom';
import '../style/AdminLogin.css';

const Login = () => {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState(null);
  const [isLoading, setIsLoading] = useState(false);
  const navigate = useNavigate();
  const location = useLocation();

  useEffect(() => {
    // Listen for auth state changes to check if the user is an admin
    const unsubscribe = onAuthStateChanged(auth, (user) => {
      if (user) {
        user.getIdTokenResult().then((idTokenResult) => {
          if (idTokenResult.claims.admin) {
            // Redirect to dashboard if user is an admin and not already on dashboard
            if (location.pathname === '/') {
              navigate('/dashboard');
            }
          } else {
            // Sign out if user is not an admin
            auth.signOut().then(() => {
              setError('Access denied: You are not an admin.');
            });
          }
        }).catch((error) => {
          setError(error.message);
        });
      }
    });
    return () => unsubscribe();
  }, [navigate, location.pathname]);

  const handleLogin = async (e) => {
    e.preventDefault();
    setIsLoading(true);
    setError(null);
    try {
      const userCredential = await signInWithEmailAndPassword(auth, email, password);
      const user = userCredential.user;
      const idTokenResult = await user.getIdTokenResult();

      if (idTokenResult.claims.admin) {
        console.log('Logged in successfully as admin!');
        navigate('/dashboard');
      } else {
        await auth.signOut();
        throw new Error('Access denied: You are not an admin.');
      }
    } catch (error) {
      setError(error.message);
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="login-container" style={{ backgroundColor: '#F5EEDC' }}>
      <div className="login-card" style={{ backgroundColor: '#4A4E69', color: 'white' }}>
        <h2>Admin Sign In</h2>
        <form onSubmit={handleLogin}>
          <div className="input-group">
            <label>Email</label>
            <input
              type="email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              placeholder="Enter your email"
              required
              disabled={isLoading}
            />
          </div>
          <div className="input-group">
            <label>Password</label>
            <input
              type="password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              placeholder="Enter your password"
              required
              disabled={isLoading}
            />
          </div>
          {error && <p className="error">{error}</p>}
          <button type="submit" disabled={isLoading}>
            {isLoading ? 'Signing In...' : 'Sign In'}
          </button>
        </form>
        {/* Optional: Add Google/Facebook login buttons if enabled in Firebase */}
        {/* <div className="social-login">
          <button className="google-btn">Sign in with Google</button>
          <button className="facebook-btn">Sign in with Facebook</button>
        </div> */}
      </div>
    </div>
  );
};

export default Login;