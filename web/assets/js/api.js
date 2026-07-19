// API Utility - Placeholder
const API = {
    async get(endpoint) {
        console.log(`[API Mock] GET ${endpoint}`);
        return { success: true, data: {} };
    },
    async post(endpoint, payload) {
        console.log(`[API Mock] POST ${endpoint}`, payload);
        return { success: true, data: {} };
    }
};
