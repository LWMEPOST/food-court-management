package com.foodcourt.service;

import com.foodcourt.entity.Lease;
import java.util.List;
import java.util.Optional;

public interface LeaseService {
    List<Lease> getAllLeases();
    List<Lease> getLeasesByOwner(Integer ownerId);
    Optional<Lease> getLeaseById(Integer id);
    Lease createLeaseApplication(Lease lease);
    boolean updateLeaseStatus(Integer id, Lease.Status status);
    boolean updateLease(Lease lease);
    String generateContract(Lease lease);
}
