package com.codeForge.clientVault.controller;

import com.codeForge.clientVault.model.Client;
import com.codeForge.clientVault.services.ClientService;
import org.apache.coyote.Response;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/clients")
public class ClientController {
    private final ClientService clientService;

    public ClientController(ClientService clientService) {
        this.clientService = clientService;
    }

    // REST controller providing Create, Read, Update, and Delete (CRUD) endpoints
    //for managing Client records in the database

    // CREATE
    @PostMapping("/add")
    public ResponseEntity<Client> createClient(@RequestBody Client client){
        Client savedClient = clientService.createClient(client);
        return new ResponseEntity<>(savedClient, HttpStatus.CREATED);
    }

    //GET ALL
    @GetMapping("/all")
    public ResponseEntity<List<Client>> getAllClients(){
        List<Client> clients = clientService.getAllClients();
        return ResponseEntity.ok(clients);
    }

    //GET by DB ID
    @GetMapping("/{id}")
    public ResponseEntity<Client> getClientById(@PathVariable Long id) {
        return ResponseEntity.ok(clientService.getClientById(id));
    }

    //UPDATE by DB ID
    @PutMapping("update/{id}")
    public ResponseEntity<Client> updateClient( @PathVariable Long id,
            @RequestBody Client updatedClient) {

        // Fetch existing client
        Client existingClient = clientService.getClientById(id);

        // Update fields
        existingClient.setFullName(updatedClient.getFullName());
        existingClient.setEmail(updatedClient.getEmail());
        existingClient.setPhoneNumber(updatedClient.getPhoneNumber());
        existingClient.setAddress(updatedClient.getAddress());

        // Save updated client
        return ResponseEntity.ok(
                clientService.updateClient(existingClient)
        );
    }

    // DELETE by DB ID
    @DeleteMapping("delete/{id}")
    public ResponseEntity<String> deleteClient(@PathVariable("id") Long clientId){
        Client client = clientService.getClientById(clientId);
        clientService.deleteClient(client);
        return ResponseEntity.ok("Client deleted successfully");
    }

}
