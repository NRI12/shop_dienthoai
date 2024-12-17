var owl = $('.owl-carousel');
owl.owlCarousel({
    items: 1.5,
    margin: 100,
    center: true,
    loop: true,
    smartSpeed: 450,
    autoplay: true,
    autoplayTimeout: 3500
});
$(document).ready(function(){
    $('.owl-carousel').owlCarousel({
        items: 3, // Số lượng ảnh nhỏ tối đa
        loop: true,
        margin: 10,
        nav: true,
        responsive: {
            0: {
                items: 1
            },
            600: {
                items: 2
            },
            1000: {
                items: 3
            }
        }
    });
});
function showAllProducts(category) {
    fetch(`/shop?category=${category}`, {
        method: 'GET'
    })
    .then(response => response.text())
    .then(html => {
        document.body.innerHTML = html;
    });
}

$(document).ready(function(){
    $('.owl-carousel').owlCarousel({
        items: 1, // Thay đổi số lượng items hiển thị nếu cần
        loop: true, // Cho phép lặp lại các slide khi đạt đến cuối danh sách
        margin: 10, // Khoảng cách giữa các slide
        nav: true, // Hiển thị nút điều hướng
        autoplay: true, // Tự động chuyển slide
        autoplayTimeout: 3000, // Thời gian chờ trước khi chuyển slide tiếp theo (3000ms = 3 giây)
        autoplayHoverPause: true, // Tạm dừng khi chuột hover trên slide
        smartSpeed: 750, // Tốc độ chuyển động của slide
        responsive: {
            0: {
                items: 1
            },
            600: {
                items: 1
            },
            1000: {
                items: 1
            }
        }
    });
});

function toggleEdit(editMode) {
    document.getElementById('fullName').disabled = !editMode;
    document.getElementById('email').disabled = !editMode;
    document.getElementById('phoneNumber').disabled = !editMode;
    document.getElementById('address').disabled = !editMode
    document.getElementById('saveChanges').style.display = editMode ? 'inline-block' : 'none';
}

document.addEventListener('DOMContentLoaded', function() {
    var form = document.getElementById('userInfoForm');
    if (form) {
        form.addEventListener('submit', function(event) {
            event.preventDefault();
            const formData = {
                fullName: document.getElementById('fullName').value,
                email: document.getElementById('email').value,
                phoneNumber: document.getElementById('phoneNumber').value,
                address: document.getElementById('address').value
            };

            fetch('/update_user_info', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Accept': 'application/json'
                },
                body: JSON.stringify(formData)
            })
            .then(response => response.json())
            .then(data => {
                alert(data.message);
                if (data.success) {
                    toggleEdit(false); // Turn off edit mode after saving
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Có lỗi xảy ra khi cập nhật thông tin. Vui lòng thử lại.');
            });
        });
    } else {
        console.error("Form element not found!");
    }
});



document.addEventListener('DOMContentLoaded', function() {
    displayCartItems();
    updateCartUI();
    displayCartNumber();
});

function displayCartItems() {
    const cart = JSON.parse(localStorage.getItem('shoppingCart')) || {};
    const cartTableBody = document.getElementById('cartTableBody');
    let index = 0;
    let html = '';
    let total = 0;

    for (const id in cart) {
        const item = cart[id];
        const totalPrice = item.price * item.quantity;
        total += totalPrice;
        html += `
            <tr>
                <td>${++index}</td>
                <td>${item.name}</td>
                <td>${item.price.toLocaleString('vi-VN', { style: 'currency', currency: 'VND' })}</td>
                <td>
                    <input type="number" value="${item.quantity}" min="1" class="form-control quantity-input" data-product-id="${id}">
                </td>
                <td>${totalPrice.toLocaleString('vi-VN', { style: 'currency', currency: 'VND' })}</td>
                <td>${item.lastUpdated}</td>
                <td>
                    <button class="btn btn-info update-btn" data-product-id="${id}">Cập nhật</button>
                    <button class="btn btn-danger delete-btn" data-product-id="${id}">Xóa</button>
                </td>
            </tr>
        `;
    }

    if (index === 0) {
        html = `
            <tr>
                <td colspan="7">
                    <h1 class="text-success text-center py-4">
                        Giỏ hàng trống !!
                    </h1>
                </td>
            </tr>
        `;
        document.getElementById('totalAmount').textContent = '';
    } else {
        document.getElementById('totalAmount').textContent = `Tổng tiền: ${total.toLocaleString('vi-VN', { style: 'currency', currency: 'VND' })}`;
    }

    cartTableBody.innerHTML = html;
    attachEventListeners();
}

function attachEventListeners() {
    document.querySelectorAll('.update-btn').forEach(button => {
        button.onclick = function() {
            const productId = this.getAttribute('data-product-id');
            const quantityInput = document.querySelector(`.quantity-input[data-product-id="${productId}"]`).value;
            updateCartItem(productId, quantityInput);
        };
    });

    document.querySelectorAll('.delete-btn').forEach(button => {
        button.onclick = function() {
            const productId = this.getAttribute('data-product-id');
            deleteCartItem(productId);
        };
    });
}

function updateCartItem(productId, quantity) {
    const cart = JSON.parse(localStorage.getItem('shoppingCart')) || {};
    if (cart[productId]) {
        cart[productId].quantity = parseInt(quantity);
        cart[productId].lastUpdated = new Date().toLocaleString('vi-VN');
        localStorage.setItem('shoppingCart', JSON.stringify(cart));
        displayCartItems();  // Refresh the cart display
        updateCartUI();  // Update the cart number indicator
    }
}

function deleteCartItem(productId) {
    const cart = JSON.parse(localStorage.getItem('shoppingCart')) || {};
    if (cart[productId]) {
        delete cart[productId];
        localStorage.setItem('shoppingCart', JSON.stringify(cart));
        displayCartItems();  // Refresh the cart display
        updateCartUI();  // Update the cart number indicator
    }
}

function updateCartUI() {
    let cart = JSON.parse(localStorage.getItem('shoppingCart')) || {};
    let totalItems = 0;
    for (let id in cart) {
        totalItems += cart[id].quantity;
    }
    const cartNumberSpan = document.querySelector('.cart-number');
    cartNumberSpan.textContent = totalItems;
}

function addToCartFromElement(element) {
    var productId = element.getAttribute('data-product-id');
    var productName = element.getAttribute('data-product-name');
    var productPrice = parseFloat(element.getAttribute('data-product-price'));

    addToCart(productId, productName, productPrice);
}

function addToCart(productId, productName, productPrice) {
    let cart = JSON.parse(localStorage.getItem('shoppingCart')) || {};
    if (cart[productId]) {
        cart[productId].quantity += 1; // Tăng số lượng nếu sản phẩm đã có trong giỏ
    } else {
        cart[productId] = {
            id: productId,  // Thêm dòng này
            name: productName,
            price: productPrice,
            quantity: 1,
            lastUpdated: new Date().toLocaleString('vi-VN')
        };
    }
    localStorage.setItem('shoppingCart', JSON.stringify(cart));
    updateCartUI();  // Cập nhật UI giỏ hàng
}

function displayCartNumber() {
    const cart = JSON.parse(localStorage.getItem('shoppingCart')) || {};
    let totalItems = 0;
    for (const id in cart) {
        totalItems += cart[id].quantity;
    }
    const cartNumberSpan = document.querySelector('.cart-number');
    if (cartNumberSpan) {
        cartNumberSpan.textContent = totalItems;
    }
}
function showPaymentOptions() {
    // Lấy phần tử tbody của giỏ hàng
    var cartTableBody = document.getElementById('cartTableBody');

    // Kiểm tra nếu chỉ có một hàng và hàng đó chứa "Giỏ hàng trống !!"
    var isEmpty = cartTableBody.rows.length === 1 && cartTableBody.querySelector('h1.text-success');

    if (isEmpty) {
        alert("Giỏ hàng của bạn đang trống! Vui lòng thêm sản phẩm trước khi thanh toán.");
        return;
    }

    // Lấy thông tin từ các trường nhập liệu của người dùng hiện tại
    fetch('/api/check_user_info')
        .then(response => response.json())
        .then(data => {
            if (!data.success) {
                alert(data.message);
            } else {
                // Hiển thị bảng thanh toán nếu mọi thứ ổn
                var paymentPanel = document.getElementById('paymentPanel');
                paymentPanel.style.display = 'block';
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('Có lỗi xảy ra khi kiểm tra thông tin người dùng. Vui lòng thử lại.');
        });
}



function submitPayment(event) {
    event.preventDefault(); // Ngăn form tự động submit

    const fullName = document.getElementById('fullName').value;
    const email = document.getElementById('email').value;
    const address = document.getElementById('address').value;
    const phoneNumber = document.getElementById('phoneNumber').value;
    const paymentMethod = document.getElementById('paymentMethod').value;

    const orderData = {
        fullName: fullName,
        email: email,
        address: address,
        phoneNumber: phoneNumber,
        paymentMethod: paymentMethod,
        cart: JSON.parse(localStorage.getItem('shoppingCart'))
    };

    fetch('/api/checkout', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(orderData)
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            alert('Đơn hàng của bạn đã được đặt thành công!');
            localStorage.removeItem('shoppingCart'); // Xóa giỏ hàng sau khi thanh toán thành công
            window.location.href = '/home'; // Chuyển hướng về trang chủ hoặc trang xác nhận
        } else {
            alert(data.message); // Hiển thị thông báo lỗi cụ thể từ server
        }
    })
    .catch(error => {
        console.error('Error:', error);
        alert('Có lỗi xảy ra khi đặt hàng. Vui lòng thử lại!');
    });
}

function cancelOrder(orderId) {
    if (confirm('Bạn có chắc chắn muốn hủy đơn hàng này?')) {
        fetch(`/cancel_order/${orderId}`, { method: 'POST' })
            .then(response => response.json())
            .then(data => {
                alert(data.message);
                if (data.success) {
                    window.location.reload();
                }
            })
            .catch(error => alert('Có lỗi xảy ra.'));
    }
}

document.addEventListener('DOMContentLoaded', function() {
    var reviewForm = document.getElementById('reviewForm');
    if (reviewForm) {
        reviewForm.addEventListener('submit', function(event) {
            event.preventDefault(); // Prevent the form from submitting through HTTP
            console.log("Form submission intercepted");

            var rating = document.getElementById('rating').value;
            var comment = document.getElementById('comment').value;
            var productId = document.getElementById('product-id').value; // Lấy product ID từ input ẩn

            console.log('Rating:', rating);
            console.log('Comment:', comment);
            console.log('Product ID:', productId);

            // Assuming '/api/submit_review' is your API endpoint
            fetch('/api/submit_review', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({
                    rating: rating,
                    comment: comment,
                    product_id: productId // Truyền product ID trong body request
                })
            })
            .then(response => response.json())
            .then(data => {
                console.log(data);
                if (data.success) {
                    alert(data.message); // Hiển thị thông báo thành công từ server
                    location.reload(); // Tải lại trang để hiển thị đánh giá mới
                } else {
                    alert('Failed to submit review: ' + data.message);
                }
            })
            .catch(error => {
                console.error('Error submitting review:', error);
                alert('Error submitting review. Please try again.');
            });
        });
    } else {
        console.log("Review form not found.");
    }
});
$(document).ready(function() {
    $('#loginForm').on('submit', function(event) {
        event.preventDefault();
        var formData = $(this).serialize();

        $.ajax({
            type: "POST",
            url: "/login",  // Cập nhật URL đúng của Flask
            data: formData,
            success: function(response) {
                if (response.success) {
                    $('#loginModal').modal('hide');
                    if (response.is_admin) {
                        window.location.href = "/admin"; // Chuyển hướng đến trang admin nếu là admin
                    } else {
                        window.location.href = "/home"; // Chuyển hướng đến trang home nếu không phải admin
                    }
                } else {
                    $('#loginErrorMessage').text(response.message).show(); // Hiển thị thông báo lỗi
                }
            },
            error: function(xhr) {
                var response = JSON.parse(xhr.responseText);
                $('#loginErrorMessage').text(response.message).show(); // Hiển thị thông báo lỗi
            }
        });
    });

    $('#registerForm').on('submit', function(event) {
        event.preventDefault(); // Ngăn chặn hành vi gửi form mặc định
        var formData = $(this).serialize(); // Lấy dữ liệu từ form

        $.ajax({
            type: "POST",
            url: "/register",  // Cập nhật URL đúng của Flask
            data: formData,
            success: function(response) {
                if (response.success) {
                    $('#registerModal').modal('hide'); // Ẩn modal nếu đăng ký thành công
                    window.location.href = "/home"; // Chuyển hướng đến trang home sau khi đăng ký thành công
                } else {
                    $('#registerErrorMessage').text(response.message).show(); // Hiển thị thông báo lỗi
                }
            },
            error: function(xhr) {
                var response = JSON.parse(xhr.responseText);
                $('#registerErrorMessage').text(response.message).show(); // Hiển thị thông báo lỗi
            }
        });
    });
});
