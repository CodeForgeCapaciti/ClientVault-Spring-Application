package com.codeForge.clientVault.services;


import com.codeForge.clientVault.model.Client;
import com.codeForge.clientVault.repo.ClientRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ClientService {

public final ClientRepo clientRepo;

    public ClientService(ClientRepo clientRepo) {
        this.clientRepo = clientRepo;
    }

    //To create a new client
    public Client createClient(Client client){
        return clientRepo.save(client);
    }

}
