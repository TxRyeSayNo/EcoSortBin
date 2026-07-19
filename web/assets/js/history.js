// History Page Logic
function openDetailModal(eventId) {
    const modal = document.getElementById('detailModal');
    if (modal) {
        document.getElementById('modalEventId').textContent = eventId;
        modal.classList.add('show');
        // Prevent body scroll
        document.body.style.overflow = 'hidden';
    }
}

function closeDetailModal() {
    const modal = document.getElementById('detailModal');
    if (modal) {
        modal.classList.remove('show');
        // Restore body scroll
        document.body.style.overflow = '';
    }
}

// Close modal when clicking outside
window.addEventListener('click', (e) => {
    const modal = document.getElementById('detailModal');
    if (e.target === modal) {
        closeDetailModal();
    }
});
