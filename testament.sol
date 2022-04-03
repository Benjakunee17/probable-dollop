// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract Testament{

address public _manager; //เวลาใช้งานต้องลบpublicออก
mapping(address=>address) _heir; //ทายาท
mapping(address=>uint) _balance;
//ทราบข้อมูล
event Create(address indexed owner,address indexed heir,uint amount);// สร้างพินายกรรม indexedทราบว่าเป็นใคร
event Report(address indexed owner,address indexed heir,uint amount);//เจ้าของพินายกรรมเป็นใคร ทายาทเป็นใคร เงินที่ส่งเท่าไร
// และก็ปิดพินายกรรม

constructor (){
    _manager = msg.sender; //จัดเรียงพินายกรรมเป็นหน้าที่manager

}

//owner create testament การสร้างพินายกรรม
function create(address heir)public payable{
    require(msg.value>0,"Please Enter Money more than 0");
    require(_balance[msg.sender]<=0,"Already Testament Exist "); //พินายกรรมนี้ถูกเขียนไปแล้ว ไม่สามารถกำหนดค่าใหม่ได้
    _heir[msg.sender] = heir;
    _balance[msg.sender] = msg.value; //จำนวนทรัพทย์สินของเจ้าของมรดก
    emit Create(msg.sender,heir,msg.value); //เรียกใช้event create
}

function getTestament(address owner) public view returns(address heir,uint amount){ //เรียกดูพินายกรรมที่ถูกสร้างขึ้นมา
    return (_heir[owner],_balance[owner]);

}
function reportOfDeath(address owner) public{ //แจ้งการเสียชีวิต โดยmanager เมื่อตรวจสอบเรียบร้อยก็จะเกิดเหตุการณ์report
    require(msg.sender ==_manager,"Unauthorised");//ตรวจสอบว่าใช้managerรึป่าว , ถ้าไม่ได้เป็นmanagerจะแจ้งการเสียชีวิตของownerไม่ได้
    require(_balance[owner]>0,"No Testament"); // ตรวจสอบว่าownerได้เขียนพินายกรรมไว้ไหม
    emit Report(owner,_heir[owner],_balance[owner]);

    payable(_heir[owner]).transfer(_balance[owner]);//โอนเงิน heirรับเงินจากbalance owner
    _balance[owner] = 0; //เปลี่ยนbalanceเป็น0 เพราะโอนเงินไปให้heirแล้ว
    _heir[owner] = address(0); //reset บัญชี

}

}
