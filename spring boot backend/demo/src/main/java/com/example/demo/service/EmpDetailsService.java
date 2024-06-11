package com.example.demo.service;

import com.example.demo.model.EmpDetails;
import com.example.demo.repository.EmployeeRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class EmpDetailsService {

    @Autowired
    private EmployeeRepository employeeRepository;

    public void saveEmpDetails(EmpDetails empDetails) {
        employeeRepository.save(empDetails);
    }

    public List<EmpDetails> getAllEmpDetails() {
        return employeeRepository.findAll();
    }

    public Optional<EmpDetails> getEmpDetailsById(Long id) {
        return employeeRepository.findById(id);
    }

    public EmpDetails updateEmpDetails(Long id, EmpDetails empDetails) {
        Optional<EmpDetails> optionalEmpDetails = employeeRepository.findById(id);
        if (optionalEmpDetails.isPresent()) {
            EmpDetails existingEmpDetails = optionalEmpDetails.get();
            existingEmpDetails.setName(empDetails.getName());
            existingEmpDetails.setAge(empDetails.getAge());
            return employeeRepository.save(existingEmpDetails);
        } else {
            return null;
        }
    }

    public void deleteEmpDetails(Long id) {
        employeeRepository.deleteById(id);
    }
}
