package com.codeForge.clientVault.services;


import com.codeForge.clientVault.model.Client;
import com.codeForge.clientVault.repo.ClientRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ClientService {

    public final ClientRepo clientRepo;

    public ClientService(ClientRepo clientRepo) {
        this.clientRepo = clientRepo;
    }

    //Returns a list of all clients
    public List<Client> getAllClients() {
        return clientRepo.findAll();
    }

    //Get a client by ID
    public Client getClientById(Long clientId) {
        return clientRepo.findById(clientId)
                .orElseThrow(() -> new IllegalStateException(
                        "The client with id " + clientId + " does not exist"
                ));
    }

    //To delete a client
    public void deleteClient(Client client) {
        clientRepo.delete(client);
    }

    //To create a new client
    public Client createClient(Client client) {
        return clientRepo.save(client);
    }

    //To update the Client
    public Client updateClient(Client client){
        if (!clientRepo.existsById(client.getId())){
            throw new RuntimeException("Client with ID Number: " + client.getId()+ "Not found");
        }
        return clientRepo.save(client);
    }

}
