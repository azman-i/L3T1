/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package offline2;

/**
 *
 * @author DELL
 */
public class Offline2 {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        insertcoin coin=new insertcoin();
        VendorMachine machine=new VendorMachine(coin);
        machine.setprice(20);
        
        machine.setcapacity(20);
        machine.InsertCoin(30);
        machine.pressButton();
      
        // TODO code application logic here
    }
    
}
