pragma solidity ^0.4.18;
pragma experimental ABIEncoderV2;


contract GSTCHAIN{
    int amount;
    int totalregistered;
    string gvtuser ;
    string gvtpassword; 
    
    
    constructor(int _amount,string username,string password) public {
        amount = _amount;
        gvtuser = username;
        gvtpassword = password;
        
    }
    
    
    function governmentLogin(string _gvtuser , string _gvtpassword) public view returns(string){
        
        if ((keccak256(abi.encodePacked(_gvtuser)) == keccak256(abi.encodePacked(gvtuser))) && (keccak256(abi.encodePacked(_gvtpassword)) == keccak256(abi.encodePacked(gvtpassword)))){
            return("Login Sucessful");
        }
        else{
            return("Login unsucessfull");
        }
    }
    
    function getGovt() public view returns(int,int)
    {
        return (amount,totalregistered);
    }
    

struct business{
        string accno;
        string gstin;
        string businessname;
        string aadharno;
        string phoneno;
        string password;
        int accbal;
        int taxpaid;
        int billgen;
        mapping(int=>generatebill) billbybillno;
        
    }


    mapping (string=>business) finder;
    business buss;
    
    function addBusiness(string _accno,string _gstin , string _businessname, string _aadharno, string _phoneno, string _password,int _accbal) public {
        buss = business(_accno,_gstin,_businessname,_aadharno, _phoneno , _password ,_accbal,0,0);
        finder[_gstin] = buss;
        totalregistered = totalregistered +1;
    }
    
    function getBusinessDetails(string _gstin) public view returns(string,string,string,string,string,string,int,int,int){
        business storage e = finder[_gstin];
        return (e.accno,e.gstin,e.businessname,e.aadharno,e.phoneno,e.password,e.accbal,e.taxpaid,e.billgen);
        
    }
    
    function businessLogin(string _gstin , string _password) public view returns(string){
        business storage e = finder[_gstin];
        if ((keccak256(abi.encodePacked(_gstin)) == keccak256(abi.encodePacked(e.gstin))) && (keccak256(abi.encodePacked(_password)) == keccak256(abi.encodePacked(e.password)))){
            return("Login Sucessful");
        }
        else{
            return("Login unsucessfull");
        }
    }
        
    
    
    struct generatebill{
        int billno;
        string gstno;
        string aadhar;
        string phnno;
        int billamnt;
        int gstamnt;
    }
    generatebill gbill;
    
    function addbilldetails(int _billno, string _gstno,string _aadhar,string _phoneno,int _billamnt,int _gstamnt) public{
        gbill = generatebill(_billno,_gstno,_aadhar,_phoneno,_billamnt,_gstamnt);
        business storage e = finder[_gstno];
        e.accbal = e.accbal + _billamnt - _gstamnt;
        e.taxpaid = e.taxpaid + _gstamnt;
        e.billgen = e.billgen +1;
        amount = amount + _gstamnt;
        e.billbybillno[_billno] =gbill;
    }
    


    function searchBill(int _billno,string _gstin) public view returns(string,string,string,int,int){
        business storage b = finder[_gstin];
        gbill = b.billbybillno[_billno];
        return (gbill.gstno,gbill.aadhar,gbill.phnno,gbill.billamnt,gbill.gstamnt);
    }
  
  
}