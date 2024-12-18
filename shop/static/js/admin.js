document.getElementById('homeLink').addEventListener('click', function () {
    hideAllContents();
    document.getElementById('homeContent').style.display = 'block';
    document.getElementById('chartsContainer').style.display = 'flex'; // Hiển thị phần tử chứa biểu đồ
    document.getElementById('topUsersContainer').style.display = 'block'; // Hiển thị bảng top người dùng
    loadDashboard();
});
document.addEventListener('DOMContentLoaded', function() {
    // Tìm phần tử 'homeLink' và thực hiện hành động click
    var homeLink = document.getElementById('homeLink');
    if (homeLink) {
        homeLink.click();
    }
});


document.getElementById('productLink').addEventListener('click', function () {
    hideAllContents();
    document.getElementById('productContent').style.display = 'block';
    document.getElementById('chartsContainer').style.display = 'none'; // Ẩn phần tử chứa biểu đồ
    document.getElementById('topUsersContainer').style.display = 'none'; // Ẩn bảng top người dùng

    loadProducts();
});

document.getElementById('orderLink').addEventListener('click', function () {
    hideAllContents();
    document.getElementById('orderContent').style.display = 'block';
    document.getElementById('chartsContainer').style.display = 'none'; // Ẩn phần tử chứa biểu đồ
    document.getElementById('topUsersContainer').style.display = 'none'; // Ẩn bảng top người dùng

    loadOrders();
});

document.getElementById('customerLink').addEventListener('click', function () {
    hideAllContents();
    document.getElementById('customerContent').style.display = 'block';
    document.getElementById('chartsContainer').style.display = 'none'; // Ẩn phần tử chứa biểu đồ
    document.getElementById('topUsersContainer').style.display = 'none'; // Ẩn bảng top người dùng

    loadCustomers();
});
function hideAllContents() {
    document.getElementById('homeContent').style.display = 'none';
    document.getElementById('productContent').style.display = 'none';
    document.getElementById('orderContent').style.display = 'none';
    document.getElementById('customerContent').style.display = 'none';
    document.getElementById('chartsContainer').style.display = 'none'; // Ẩn phần tử chứa biểu đồ
    document.getElementById('topUsersContainer').style.display = 'none'; // Ẩn bảng top người dùng
    
    // Hủy biểu đồ khi chuyển sang trang khác
    if (salesChart !== null && typeof salesChart.destroy === 'function') {
        salesChart.destroy();
        salesChart = null;
    }
    if (orderChart !== null && typeof orderChart.destroy === 'function') {
        orderChart.destroy();
        orderChart = null;
    }
    if (brandShareChart !== null && typeof brandShareChart.destroy === 'function') {
        brandShareChart.destroy();
        brandShareChart = null;
    }
}

let salesChart = null;
let orderChart = null;
let brandShareChart = null;

function formatCurrency(value) {
    return value.toLocaleString('vi-VN', { style: 'currency', currency: 'VND' }).replace('₫', 'VND');
}

function loadDashboard() {
    console.log("Bắt đầu tải dữ liệu dashboard...");
    fetch('/api/dashboard')
        .then(response => response.json())
        .then(data => {
            console.log("Dữ liệu dashboard đã tải xong:", data);
            document.getElementById('newOrdersCount').innerText = data.new_orders_count_today;
            document.getElementById('percentChange').innerText = data.total_stock;
            document.getElementById('userRegistrationsCount').innerText = data.user_registrations_count;
            document.getElementById('totalSalesValue').innerText = formatCurrency(data.total_sales_value);

            // Biểu đồ doanh số
            const ctx1 = document.getElementById('salesChart').getContext('2d');
            if (salesChart !== null && typeof salesChart.destroy === 'function') {
                salesChart.destroy();
            }
            salesChart = new Chart(ctx1, {
                type: 'bar',
                data: {
                    labels: data.sales_data.map(d => moment(d.date).format('YYYY-MM-DD')),
                    datasets: [{
                        label: 'Doanh số (VND)',
                        data: data.sales_data.map(d => d.sales),
                        backgroundColor: 'rgba(75, 192, 192, 0.2)',
                        borderColor: 'rgba(75, 192, 192, 1)',
                        borderWidth: 1,
                        fill: false
                    }]
                },
                options: {
                    scales: {
                        x: {
                            type: 'time',
                            time: {
                                unit: 'day',
                                tooltipFormat: 'DD/MM/YYYY'
                            },
                            ticks: {
                                source: 'labels'
                            }
                        },
                        y: {
                            beginAtZero: true,
                            ticks: {
                                callback: function(value) {
                                    return formatCurrency(value);
                                }
                            }
                        }
                    }
                }
            });

            // Biểu đồ số đơn đặt hàng
            const ctx2 = document.getElementById('orderChart').getContext('2d');
            if (orderChart !== null && typeof orderChart.destroy === 'function') {
                orderChart.destroy();
            }
            orderChart = new Chart(ctx2, {
                type: 'line',
                data: {
                    labels: data.order_data.map(d => moment(d.date).format('YYYY-MM-DD')),
                    datasets: [{
                        label: 'Số đơn đặt hàng',
                        data: data.order_data.map(d => d.count),
                        backgroundColor: 'rgba(153, 102, 255, 0.2)',
                        borderColor: 'rgba(153, 102, 255, 1)',
                        borderWidth: 1,
                        fill: false
                    }]
                },
                options: {
                    scales: {
                        x: {
                            type: 'time',
                            time: {
                                unit: 'day',
                                tooltipFormat: 'DD/MM/YYYY'
                            },
                            ticks: {
                                source: 'labels'
                            }
                        },
                        y: {
                            beginAtZero: true
                        }
                    }
                }
            });

            // Biểu đồ thị phần thương hiệu
            const ctx3 = document.getElementById('brandShareChart').getContext('2d');
            if (brandShareChart !== null && typeof brandShareChart.destroy === 'function') {
                brandShareChart.destroy();
            }
            brandShareChart = new Chart(ctx3, {
                type: 'pie',
                data: {
                    labels: data.brand_share.map(b => b.brand),
                    datasets: [{
                        label: 'Thị phần thương hiệu (%)',
                        data: data.brand_share.map(b => b.product_count),
                        backgroundColor: [
                            'rgba(255, 99, 132, 0.2)',
                            'rgba(54, 162, 235, 0.2)',
                            'rgba(255, 206, 86, 0.2)',
                            'rgba(75, 192, 192, 0.2)',
                            'rgba(153, 102, 255, 0.2)',
                            'rgba(255, 159, 64, 0.2)',
                            'rgba(199, 199, 199, 0.2)',
                            'rgba(83, 102, 255, 0.2)'
                        ],
                        borderColor: [
                            'rgba(255, 99, 132, 1)',
                            'rgba(54, 162, 235, 1)',
                            'rgba(255, 206, 86, 1)',
                            'rgba(75, 192, 192, 1)',
                            'rgba(153, 102, 255, 1)',
                            'rgba(255, 159, 64, 1)',
                            'rgba(199, 199, 199, 1)',
                            'rgba(83, 102, 255, 1)'
                        ],
                        borderWidth: 1
                    }]
                },
                options: {
                    responsive: true,
                    plugins: {
                        legend: {
                            position: 'top',
                        },
                        tooltip: {
                            callbacks: {
                                label: function(tooltipItem) {
                                    let total = 0;
                                    data.brand_share.forEach(b => total += b.product_count);
                                    let value = data.brand_share[tooltipItem.dataIndex].product_count;
                                    let percentage = ((value / total) * 100).toFixed(2);
                                    return `${tooltipItem.label}: ${value} (${percentage}%)`;
                                }
                            }
                        }
                    }
                }
            });

            // Hiển thị dữ liệu top người dùng
            const topUsersTableBody = document.getElementById('topUsersTableBody');
            topUsersTableBody.innerHTML = '';
            data.top_users.forEach(user => {
                const row = document.createElement('tr');
                row.innerHTML = `
                    <td>${user.username}</td>
                    <td>${user.order_count}</td>
                    <td>${formatCurrency(user.total_spent)}</td>
                `;
                topUsersTableBody.appendChild(row);
            });
            
        })
        .catch(error => {
            console.error("Có lỗi xảy ra khi tải dữ liệu dashboard:", error);
            alert('Có lỗi xảy ra: ' + error.message);
        });
}

function loadProducts() {
    fetch('/api/products')
        .then(response => response.json())
        .then(data => {
            const productTableBody = document.getElementById('productTableBody');
            productTableBody.innerHTML = '';
            data.forEach(product => {
                const row = document.createElement('tr');
                row.innerHTML = `
                    <td>${product.id}</td>
                    <td>${product.name}</td>
                    <td>${product.description}</td>
                    <td>${product.price}</td>
                    <td>${product.stock}</td>
                    <td>${product.promotion_text}</td>
                    <td>
                        <div class="action-buttons">
                            <button class="btn btn-edit" onclick="showEditProductModal(${product.id})"><i class="fa fa-pencil"></i></button>
                            <button class="btn btn-delete" onclick="deleteProduct(${product.id})"><i class="fa fa-trash"></i></button>
                        </div>
                    </td>
                `;
                productTableBody.appendChild(row);
            });
        });
}
function showEditProductModal(productId) {
    fetch(`/api/products/${productId}`)
        .then(response => response.json())
        .then(product => {
            document.getElementById('editProductId').value = product.id;
            document.getElementById('editProductName').value = product.name;
            document.getElementById('editProductDescription').value = product.description;
            document.getElementById('editProductPrice').value = product.price;
            document.getElementById('editProductStock').value = product.stock;
            document.getElementById('editProductPromotion').value = product.promotion_text;
            document.getElementById('editProductScreen').value = product.screen;
            document.getElementById('editProductCPU').value = product.cpu;
            document.getElementById('editProductRAM').value = product.ram;
            document.getElementById('editProductStorage').value = product.storage;
            document.getElementById('editProductCamera').value = product.camera;
            document.getElementById('editProductOS').value = product.os;
            document.getElementById('editProductFeatures').value = product.features;
            document.getElementById('editProductBattery').value = product.battery;
            // Clear previous images
            document.getElementById('editProductImages').value = '';
            $('#editProductModal').modal('show');
        });
}

document.getElementById('editProductForm').addEventListener('submit', function (event) {
    event.preventDefault();
    const productId = document.getElementById('editProductId').value;
    const formData = new FormData();
    formData.append('name', document.getElementById('editProductName').value);
    formData.append('description', document.getElementById('editProductDescription').value);
    formData.append('price', document.getElementById('editProductPrice').value);
    formData.append('stock', document.getElementById('editProductStock').value);
    formData.append('promotion_text', document.getElementById('editProductPromotion').value);
    formData.append('screen', document.getElementById('editProductScreen').value);
    formData.append('cpu', document.getElementById('editProductCPU').value);
    formData.append('ram', document.getElementById('editProductRAM').value);
    formData.append('storage', document.getElementById('editProductStorage').value);
    formData.append('camera', document.getElementById('editProductCamera').value);
    formData.append('os', document.getElementById('editProductOS').value);
    formData.append('features', document.getElementById('editProductFeatures').value);
    formData.append('battery', document.getElementById('editProductBattery').value);

    const images = document.getElementById('editProductImages').files;
    for (let i = 0; i < images.length; i++) {
        formData.append('images', images[i]);
    }

    fetch(`/api/products/${productId}`, {
        method: 'PUT',
        body: formData,
    })
        .then(response => response.json())
        .then(data => {
            $('#editProductModal').modal('hide');
            loadProducts();
        });
});

function showAddProductModal() {
    $('#addProductModal').modal('show');
}

document.getElementById('addProductForm').addEventListener('submit', function (event) {
    event.preventDefault();
    const formData = new FormData();
    formData.append('name', document.getElementById('addProductName').value);
    formData.append('description', document.getElementById('addProductDescription').value);
    formData.append('price', document.getElementById('addProductPrice').value);
    formData.append('stock', document.getElementById('addProductStock').value);
    formData.append('promotion_text', document.getElementById('addProductPromotion').value);
    formData.append('screen', document.getElementById('addProductScreen').value);
    formData.append('cpu', document.getElementById('addProductCPU').value);
    formData.append('ram', document.getElementById('addProductRAM').value);
    formData.append('storage', document.getElementById('addProductStorage').value);
    formData.append('camera', document.getElementById('addProductCamera').value);
    formData.append('os', document.getElementById('addProductOS').value);
    formData.append('features', document.getElementById('addProductFeatures').value);
    formData.append('battery', document.getElementById('addProductBattery').value);

    const images = document.getElementById('addProductImages').files;
    for (let i = 0; i < images.length; i++) {
        formData.append('images', images[i]);
    }

    fetch(`/api/products`, {
        method: 'POST',
        body: formData,
    })
        .then(response => response.json())
        .then(data => {
            $('#addProductModal').modal('hide');
            loadProducts();
        });
});
function loadOrders() {
    fetch('/api/orders')
        .then(response => response.json())
        .then(data => {
            const orderTableBody = document.getElementById('orderTableBody');
            orderTableBody.innerHTML = '';
            data.forEach(order => {
                const row = document.createElement('tr');
                row.innerHTML = `
                    <td>${order.id}</td>
                    <td>${order.user_id}</td>
                    <td>${order.total}</td>
                    <td>${order.status}</td>
                    <td>${order.order_date}</td>
                    <td>${order.address}</td>
                    <td>
                        <div class="action-buttons">
                            <button class="btn btn-edit" onclick="showEditOrderModal(${order.id})"><i class="fa fa-pencil"></i></button>
                            <button class="btn btn-delete" onclick="deleteOrder(${order.id})"><i class="fa fa-trash"></i></button>
                        </div>
                    </td>
                `;
                orderTableBody.appendChild(row);
            });
        });
}

function showEditOrderModal(orderId) {
    fetch(`/api/orders/${orderId}`)
        .then(response => response.json())
        .then(order => {
            document.getElementById('editOrderId').value = order.id;
            document.getElementById('editOrderStatus').value = order.status;
            document.getElementById('editOrderAddress').value = order.address;
            $('#editOrderModal').modal('show');
        });
}

document.getElementById('editOrderForm').addEventListener('submit', function (event) {
    event.preventDefault();
    const orderId = document.getElementById('editOrderId').value;
    const orderData = {
        status: document.getElementById('editOrderStatus').value,
        address: document.getElementById('editOrderAddress').value
    };
    fetch(`/api/orders/${orderId}`, {
        method: 'PUT',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify(orderData),
    })
        .then(response => response.json())
        .then(data => {
            $('#editOrderModal').modal('hide');
            loadOrders();
        });
});

function deleteOrder(orderId) {
    if (confirm('Bạn có chắc chắn muốn xóa đơn hàng này?')) {
        fetch(`/api/orders/${orderId}`, {
            method: 'DELETE',
        })
            .then(response => response.json())
            .then(data => {
                loadOrders();
            });
    }
}
function loadCustomers() {
    fetch('/api/customers')
        .then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok');
            }
            return response.json();
        })
        .then(data => {
            const customerTableBody = document.getElementById('customerTableBody');
            customerTableBody.innerHTML = '';
            data.forEach(customer => {
                const row = document.createElement('tr');
                row.innerHTML = `
                    <td>${customer.id}</td>
                    <td>${customer.username}</td>
                    <td>${customer.email}</td>
                    <td>${customer.full_name}</td>
                    <td>${customer.birth_date}</td>
                    <td>${customer.address}</td>
                    <td>${customer.phone_number}</td>
                    <td>${customer.order_count || 0}</td>
                    <td>${customer.total_spent || 0}</td>
                    <td>
                        <div class="action-buttons">
                            <button class="btn btn-edit" onclick="showEditCustomerModal(${customer.id})"><i class="fa fa-pencil"></i></button>
                            <button class="btn btn-delete" onclick="deleteCustomer(${customer.id})"><i class="fa fa-trash"></i></button>
                        </div>
                    </td>
                `;
                customerTableBody.appendChild(row);
            });
        })
        .catch(error => {
            alert('Có lỗi xảy ra: ' + error.message);
        });
}

function showEditCustomerModal(customerId) {
    fetch(`/api/customers/${customerId}`)
        .then(response => response.json())
        .then(customer => {
            document.getElementById('editCustomerId').value = customer.id;
            document.getElementById('editCustomerUsername').value = customer.username;
            document.getElementById('editCustomerEmail').value = customer.email;
            document.getElementById('editCustomerFullName').value = customer.full_name;
            document.getElementById('editCustomerBirthDate').value = customer.birth_date;
            document.getElementById('editCustomerAddress').value = customer.address;
            document.getElementById('editCustomerPhoneNumber').value = customer.phone_number;
            $('#editCustomerModal').modal('show');
        });
}
document.getElementById('editCustomerForm').addEventListener('submit', function (event) {
    event.preventDefault();
    const customerId = document.getElementById('editCustomerId').value;
    const customerData = {
        username: document.getElementById('editCustomerUsername').value,
        email: document.getElementById('editCustomerEmail').value,
        full_name: document.getElementById('editCustomerFullName').value,
        birth_date: document.getElementById('editCustomerBirthDate').value,
        address: document.getElementById('editCustomerAddress').value,
        phone_number: document.getElementById('editCustomerPhoneNumber').value
    };
    fetch(`/api/customers/${customerId}`, {
        method: 'PUT',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify(customerData),
    })
        .then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok');
            }
            return response.json();
        })
        .then(data => {
            $('#editCustomerModal').modal('hide');
            loadCustomers();
        })
        .catch(error => {
            alert('Có lỗi xảy ra: ' + error.message);
        });
});

function showAddCustomerModal() {
    $('#addCustomerModal').modal('show');
}
document.getElementById('addCustomerForm').addEventListener('submit', function (event) {
    event.preventDefault();
    const customerData = {
        username: document.getElementById('addCustomerUsername').value,
        email: document.getElementById('addCustomerEmail').value,
        password: document.getElementById('addCustomerPassword').value,
        full_name: document.getElementById('addCustomerFullName').value,
        birth_date: document.getElementById('addCustomerBirthDate').value,
        address: document.getElementById('addCustomerAddress').value,
        phone_number: document.getElementById('addCustomerPhoneNumber').value
    };
    fetch(`/api/customers`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify(customerData),
    })
        .then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok');
            }
            return response.json();
        })
        .then(data => {
            $('#addCustomerModal').modal('hide');
            loadCustomers();
        })
        .catch(error => {
            alert('Có lỗi xảy ra: ' + error.message);
        });
});
function deleteCustomer(customerId) {
    if (confirm('Bạn có chắc chắn muốn xóa khách hàng này?')) {
        fetch(`/api/customers/${customerId}`, {
            method: 'DELETE',
        })
            .then(response => response.json())
            .then(data => {
                loadCustomers();
            });
    }
}
function deleteProduct(productId) {
    if (confirm('Bạn có chắc chắn muốn xóa sản phẩm này?')) {
        fetch(`/api/products/${productId}`, {
            method: 'DELETE',
        })
        .then(response => response.json())
        .then(data => {
            if (data.error) {
                alert('Error: ' + data.error);
            } else {
                // Reload the negative reviews summary to reflect the deletion
                loadNegativeReviewsSummary();
            }
        });
    }
}


