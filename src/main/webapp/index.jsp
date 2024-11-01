<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Danh Sách Tài Khoản</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      margin: 20px;
    }
    table {
      width: 100%;
      border-collapse: collapse;
    }
    th, td {
      padding: 10px;
      text-align: left;
      border: 1px solid #ccc;
    }
    th {
      background-color: #f2f2f2;
    }
    .button {
      margin: 5px;
    }
  </style>
  <script>
    let accounts = []; // Mảng lưu trữ tài khoản

    async function fetchAccounts() {
      try {
        const response = await fetch('http://localhost:8080/rest-1.0-SNAPSHOT/api/accounts');
        if (!response.ok) {
          throw new Error('Network response was not ok');
        }
        accounts = await response.json();
        console.log('Accounts received:', accounts); // Log dữ liệu để kiểm tra
        displayAccounts(accounts);
      } catch (error) {
        console.error('Error fetching accounts:', error);
        alert('Đã xảy ra lỗi khi lấy danh sách tài khoản.');
      }
    }

    function displayAccounts(accounts) {
      const tableBody = document.getElementById('accountTableBody');
      tableBody.innerHTML = ''; // Xóa nội dung cũ

      if (accounts.length === 0) {
        const row = document.createElement('tr');
        const cell = document.createElement('td');
        cell.colSpan = 5;
        cell.textContent = 'Không tìm thấy tài khoản nào';
        row.appendChild(cell);
        tableBody.appendChild(row);
        return;
      }

      accounts.forEach(account => {
        const row = document.createElement('tr');

        const idCell = document.createElement('td');
        idCell.textContent = account.id;
        row.appendChild(idCell);

        const usernameCell = document.createElement('td');
        usernameCell.textContent = account.username;
        row.appendChild(usernameCell);

        const emailCell = document.createElement('td');
        emailCell.textContent = account.email;
        row.appendChild(emailCell);

        const addressCell = document.createElement('td');
        addressCell.textContent = account.address;
        row.appendChild(addressCell);

        // Thêm nút Sửa và Xóa
        const actionsCell = document.createElement('td');

        const editButton = document.createElement('button');
        editButton.textContent = 'Sửa';
        editButton.classList.add('button');
        editButton.onclick = () => editAccount(account.id);
        actionsCell.appendChild(editButton);

        const deleteButton = document.createElement('button');
        deleteButton.textContent = 'Xóa';
        deleteButton.classList.add('button');
        deleteButton.onclick = () => deleteAccount(account.id);
        actionsCell.appendChild(deleteButton);

        row.appendChild(actionsCell);
        tableBody.appendChild(row);
      });
    }

    function addAccount() {
      const username = prompt('Nhập tên người dùng mới:');
      const email = prompt('Nhập email mới:');
      const address = prompt('Nhập địa chỉ mới:');

      if (username && email && address) {
        fetch('http://localhost:8080/rest-1.0-SNAPSHOT/api/accounts', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
          },
          body: JSON.stringify({ username, email, address }),
        })
                .then(response => {
                  if (!response.ok) {
                    throw new Error('Network response was not ok');
                  }
                  fetchAccounts(); // Cập nhật danh sách tài khoản
                })
                .catch(error => {
                  console.error('Error adding account:', error);
                  alert('Đã xảy ra lỗi khi thêm tài khoản.');
                });
      }
    }

    function editAccount(id) {
      const account = accounts.find(acc => acc.id === id);
      if (account) {
        const newUsername = prompt('Nhập tên người dùng mới:', account.username);
        const newEmail = prompt('Nhập email mới:', account.email);
        const newAddress = prompt('Nhập địa chỉ mới:', account.address);

        if (newUsername && newEmail && newAddress) {
          fetch("http://localhost:8080/rest-1.0-SNAPSHOT/api/accounts/"+id, {
            method: 'PUT',
            headers: {
              'Content-Type': 'application/json',
            },
            body: JSON.stringify({ username: newUsername, email: newEmail, address: newAddress }),
          })
                  .then(response => {
                    if (!response.ok) {
                      throw new Error('Network response was not ok');
                    }
                    fetchAccounts(); // Cập nhật danh sách tài khoản
                  })
                  .catch(error => {
                    console.error('Error updating account:', error);
                    alert('Đã xảy ra lỗi khi cập nhật tài khoản.');
                  });
        }
      }
    }

    function deleteAccount(id) {
      if (confirm('Bạn có chắc chắn muốn xóa tài khoản này?')) {
        fetch("http://localhost:8080/rest-1.0-SNAPSHOT/api/accounts/"+id, {
          method: 'DELETE',
        })
                .then(response => {
                  if (!response.ok) {
                    throw new Error('Network response was not ok');
                  }
                  fetchAccounts(); // Cập nhật danh sách tài khoản
                })
                .catch(error => {
                  console.error('Error deleting account:', error);
                  alert('Đã xảy ra lỗi khi xóa tài khoản.');
                });
      }
    }

    function searchAccounts() {
      const query = document.getElementById('searchInput').value.toLowerCase();
      const filteredAccounts = accounts.filter(account =>
              account.username.toLowerCase().includes(query) ||
              account.email.toLowerCase().includes(query)
      );
      displayAccounts(filteredAccounts);
    }

    document.addEventListener('DOMContentLoaded', fetchAccounts);
  </script>
</head>
<body>
<h1>Danh Sách Tài Khoản</h1>
<button onclick="addAccount()" class="button">Thêm Tài Khoản</button> <!-- Nút thêm tài khoản -->
<input type="text" id="searchInput" placeholder="Tìm kiếm..." onkeyup="searchAccounts()">
<table>
  <thead>
  <tr>
    <th>ID</th>
    <th>Tên Người Dùng</th>
    <th>Email</th>
    <th>Địa chỉ</th>
    <th>Thao tác</th>
  </tr>
  </thead>
  <tbody id="accountTableBody">
  <!-- JavaScript sẽ điền dữ liệu vào đây -->
  </tbody>
</table>
</body>
</html>
