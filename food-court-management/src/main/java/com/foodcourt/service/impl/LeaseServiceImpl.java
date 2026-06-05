package com.foodcourt.service.impl;

import com.foodcourt.dao.LeaseDao;
import com.foodcourt.dao.impl.LeaseDaoImpl;
import com.foodcourt.entity.Lease;
import com.foodcourt.service.LeaseService;

import java.text.SimpleDateFormat;
import java.util.List;
import java.util.Optional;

public class LeaseServiceImpl implements LeaseService {
    private final LeaseDao leaseDao = new LeaseDaoImpl();

    @Override
    public List<Lease> getAllLeases() {
        return leaseDao.findAll();
    }

    @Override
    public List<Lease> getLeasesByOwner(Integer ownerId) {
        return leaseDao.findByOwnerId(ownerId);
    }

    @Override
    public Optional<Lease> getLeaseById(Integer id) {
        return leaseDao.findById(id);
    }

    @Override
    public Lease createLeaseApplication(Lease lease) {
        // Set defaults if missing
        if (lease.getStatus() == null) {
            lease.setStatus(Lease.Status.PENDING);
        }
        return leaseDao.save(lease);
    }

    @Override
    public boolean updateLeaseStatus(Integer id, Lease.Status status) {
        Optional<Lease> leaseOpt = leaseDao.findById(id);
        if (leaseOpt.isPresent()) {
            Lease lease = leaseOpt.get();
            lease.setStatus(status);
            return leaseDao.update(lease);
        }
        return false;
    }

    @Override
    public boolean updateLease(Lease lease) {
        return leaseDao.update(lease);
    }

    @Override
    public String generateContract(Lease lease) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        StringBuilder sb = new StringBuilder();
        sb.append("美食街摊位租赁合同\n\n");
        sb.append("合同编号：LEASE-").append(lease.getId()).append("\n");
        sb.append("甲方：美食街管理方\n");
        sb.append("乙方（摊主）：").append(lease.getOwnerName() != null ? lease.getOwnerName() : "未知").append("\n\n");
        sb.append("根据相关法律法规，甲乙双方经友好协商，达成如下协议：\n");
        sb.append("1. 租赁标的：摊位ID ").append(lease.getStallId() != null ? lease.getStallId() : "待分配").append("\n");
        sb.append("2. 租赁期限：自 ").append(sdf.format(lease.getStartDate()))
          .append(" 起至 ").append(sdf.format(lease.getEndDate())).append(" 止。\n");
        sb.append("3. 租金支付：乙方应按时缴纳租金及管理费。\n");
        sb.append("4. 经营规范：乙方需遵守美食街各项管理规定。\n\n");
        sb.append("甲方盖章：[电子章]\n");
        sb.append("乙方签字：[电子签名]\n");
        sb.append("日期：").append(sdf.format(new java.util.Date()));
        
        return sb.toString();
    }
}
