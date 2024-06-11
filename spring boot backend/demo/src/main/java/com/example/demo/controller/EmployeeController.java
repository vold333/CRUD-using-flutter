package com.example.demo.controller;

import com.example.demo.model.EmpDetails;
import com.example.demo.service.EmpDetailsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/empdetails")
@CrossOrigin
public class EmployeeController {

    @Autowired
    private EmpDetailsService empDetailsService;

    @PostMapping("/add")
    public String add(@RequestBody EmpDetails empDetails){
        empDetailsService.saveEmpDetails(empDetails);
        return "New employee is added";
    }

    @GetMapping("/{id}")
    public Optional<EmpDetails> getById(@PathVariable Long id) {
        return empDetailsService.getEmpDetailsById(id);
    }

    @GetMapping("/all")
    public List<EmpDetails> getAllEmpDetails() {
        return empDetailsService.getAllEmpDetails();
    }

    @PutMapping("/update")
    public String update(@RequestBody EmpDetails empDetails) {
        empDetailsService.updateEmpDetails(empDetails.getId(), empDetails);
        return "Employee record updated";
    }

    @DeleteMapping("/delete/{id}")
    public String delete(@PathVariable Long id) {
        empDetailsService.deleteEmpDetails(id);
        return "Employee record deleted";
    }
}
