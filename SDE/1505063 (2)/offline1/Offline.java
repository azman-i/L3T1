/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package offline;

/**
 *
 * @author DELL
 */
public class Offline {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        // TODO code application logic here
        Subject sub=new Subject();
        Observer1 ob1=new Observer1();
        Observer2 ob2=new Observer2();
        sub.register(ob1);
        sub.register(ob2);
        sub.setmystring("tomorrow is at 11");
        sub.unregister(ob2);
         sub.setmystring("tomorrow is at 11");
    }
    
}
