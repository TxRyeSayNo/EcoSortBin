<%@ page pageEncoding="UTF-8" %>
<!-- Modal Backdrop -->
<div class="modal-backdrop" id="detailModal">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h3 class="modal-title">Chi tiết sự kiện #<span id="modalEventId">125</span></h3>
                <button class="modal-close" onclick="closeDetailModal()">
                    <i class="fa-solid fa-xmark"></i>
                </button>
            </div>
            <div class="modal-body">
                <div class="detail-grid">
                    <div class="detail-item">
                        <div class="detail-label">Thiết bị</div>
                        <div class="detail-value">SMART_BIN_001</div>
                    </div>
                    <div class="detail-item">
                        <div class="detail-label">Thời gian</div>
                        <div class="detail-value">11/07/2026 20:35:12</div>
                    </div>
                    <div class="detail-item">
                        <div class="detail-label">Loại rác</div>
                        <div class="detail-value"><span class="waste-badge waste-plastic">Nhựa</span></div>
                    </div>
                    <div class="detail-item">
                        <div class="detail-label">Confidence</div>
                        <div class="detail-value font-mono">95.2%</div>
                    </div>
                    <div class="detail-item">
                        <div class="detail-label">Thời gian nhận diện</div>
                        <div class="detail-value font-mono">1200 ms</div>
                    </div>
                    <div class="detail-item">
                        <div class="detail-label">Thời gian phân luồng</div>
                        <div class="detail-value font-mono">800 ms</div>
                    </div>
                    <div class="detail-item">
                        <div class="detail-label">Tổng thời gian</div>
                        <div class="detail-value font-mono">2000 ms</div>
                    </div>
                    <div class="detail-item">
                        <div class="detail-label">Kết quả phân luồng</div>
                        <div class="detail-value text-success"><i class="fa-solid fa-check"></i> Thành công</div>
                    </div>
                    <div class="detail-item">
                        <div class="detail-label">Cảm biến xác nhận</div>
                        <div class="detail-value text-success">Có</div>
                    </div>
                    <div class="detail-item">
                        <div class="detail-label">Mã lỗi</div>
                        <div class="detail-value text-secondary">Không có</div>
                    </div>
                </div>
                
                <div class="detail-section">
                    <div class="detail-label mb-2">Payload gốc (JSON)</div>
                    <pre class="json-payload">
{
  "wasteType": "PLASTIC",
  "confidence": 95.2,
  "classificationTimeMs": 1200,
  "sortingTimeMs": 800,
  "totalProcessingTimeMs": 2000,
  "sortingSuccess": true,
  "sensorConfirmed": true
}
                    </pre>
                </div>
            </div>
            <div class="modal-footer">
                <button class="btn btn-outline" onclick="closeDetailModal()">Đóng</button>
            </div>
        </div>
    </div>
</div>
