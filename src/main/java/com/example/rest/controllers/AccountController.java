package com.example.rest.controllers;

import com.example.rest.entities.Account;
import com.example.rest.models.AccountModel;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;

import java.util.List;

@Path("/accounts") // Đường dẫn đến tài khoản
@Produces(MediaType.APPLICATION_JSON) // Định dạng trả về là JSON
@Consumes(MediaType.APPLICATION_JSON) // Định dạng nhận vào là JSON
public class AccountController {

    @Inject
    private AccountModel model; // Inject model để sử dụng

    // Lấy danh sách tài khoản
    @GET
    public Response getAccounts() {
        List<Account> accounts = model.listAccounts(); // Gọi model để lấy danh sách tài khoản
        return Response.ok(accounts).build(); // Trả về danh sách tài khoản với mã 200
    }

    // Lấy tài khoản theo ID
    @GET
    @Path("/{id}") // Đường dẫn bao gồm ID
    public Response getAccountById(@PathParam("id") Long id) {
        Account account = model.findAccountById(id); // Tìm tài khoản theo ID
        if (account != null) {
            return Response.ok(account).build(); // Nếu tìm thấy, trả về tài khoản
        } else {
            return Response.status(Response.Status.NOT_FOUND).build(); // Không tìm thấy, trả về mã 404
        }
    }

    // Tạo tài khoản mới
    @POST
    @Transactional // Đánh dấu phương thức là giao dịch
    public Response createAccount(Account account) {
        model.updateAccount(account); // Giả sử updateAccount() cũng thực hiện tạo mới
        return Response.status(Response.Status.CREATED).entity(account).build(); // Trả về tài khoản đã tạo với mã 201
    }

    // Cập nhật tài khoản theo ID
    @PUT
    @Path("/{id}") // Đường dẫn bao gồm ID
    @Transactional // Đánh dấu phương thức là giao dịch
    public Response updateAccount(@PathParam("id") Long id, Account account) {
        account.setId(id); // Gán ID cho tài khoản để đảm bảo cập nhật đúng
        model.updateAccount(account); // Cập nhật tài khoản
        return Response.ok(account).build(); // Trả về tài khoản đã cập nhật
    }

    // Xóa tài khoản theo ID
    @DELETE
    @Path("/{id}") // Đường dẫn bao gồm ID
    @Transactional // Đánh dấu phương thức là giao dịch
    public Response deleteAccount(@PathParam("id") Long id) {
        model.deleteAccount(id); // Gọi phương thức xóa tài khoản
        return Response.noContent().build(); // Trả về mã 204 No Content
    }
}
