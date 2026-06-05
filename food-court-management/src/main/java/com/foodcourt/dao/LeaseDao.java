package com.foodcourt.dao;

import com.foodcourt.entity.Lease;
import java.util.List;
import java.util.Optional;

public interface LeaseDao {
    List<Lease> findAll();
    List<Lease> findByOwnerId(Integer ownerId);
    Optional<Lease> findById(Integer id);
    Lease save(Lease lease);
    boolean update(Lease lease);
    boolean delete(Integer id);
}
