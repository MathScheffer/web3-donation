
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

struct Campaign {
    address author;
    string title;
    string description;
    string videoUrl;
    string imageUrl;
    uint256 balance;
    bool active;
}
contract DonateCrypto {
    //qualquer pessoa consegue acessar na blockchain
    uint256 public fee = 100;//wei
    uint256 public nextId = 0;

    mapping(uint256 => Campaign) public campaings;
    //calldata -> Dados temporários que não são escritos na blockchain, mas podem ser lidos eventualmente
    function addCampaing(string calldata title, string calldata description, string calldata videoUrl, string calldata imageUrl) public{
        Campaign memory newCampaing;
        newCampaing.author = msg.sender;//o endereço do usuário que chamou a função
        newCampaing.title = title; //campanha de mensagem recebida pelos parâmetros
        newCampaing.description = description; 
        newCampaing.videoUrl = videoUrl;//https://www.youtube.com/watch?v=06C-qZYLB4Q&list=PLWdR2nNXI53Ub8pGmj1uJEeFs7zgHxk9rD  
        newCampaing.active = true;
        nextId++;
        campaings[nextId] = newCampaing;
    }

    function donate(uint256 id) public payable {
        
        require(campaings[id].active, "Campanha nao esta ativa!");
        require(msg.value > 0, "Valor precisa ser maior que zero.");

        campaings[id].balance += msg.value;
    }

    function deactivateCampaing(uint256 id) public {
        campaings[id].active = false;
    }

    function Withdraw(uint256 id) public {
        Campaign memory  campaign = campaings[id];
        require(campaign.author == msg.sender, "Somente o autor pode sacar.");
        require(campaign.active, "Campanha nao esta ativa!");
        require(campaign.balance > fee, "Saldo total menor que a taxa de cobranca.");

        address payable recipient = payable(campaign.author);
        recipient.call{value: campaign.balance - fee}("");

        campaings[id].active = false;
    }
}