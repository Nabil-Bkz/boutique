// API configuration
// In production, set VITE_API_URL environment variable
// Example: VITE_API_URL=http://35.180.255.192:8000
const API_URL = import.meta.env.VITE_API_URL || 'http://localhost:8000';

export const API_BASE = `${API_URL}/api`;
export const ADMIN_BASE_URL = `${API_URL}/admin/`;

