package com.example.rest.models;

import com.example.rest.entities.Account;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;
import jakarta.transaction.Transactional;

import java.util.List;

public class AccountModel {

    @PersistenceContext(name = "demo")
    private EntityManager em;

    public List<Account> listAccounts() {
        TypedQuery<Account> q = em.createQuery("SELECT a FROM Account a", Account.class);
        return q.getResultList();
    }

    public Account findAccountById(Long id) {
        return em.find(Account.class, id);
    }

    @Transactional
    public void updateAccount(Account account) {
        em.merge(account); // Cập nhật thông tin tài khoản
    }

    @Transactional
    public void deleteAccount(Long id) {
        Account account = findAccountById(id);
        if (account != null) {
            em.remove(account); // Xóa tài khoản nếu tồn tại
        }
    }
}
