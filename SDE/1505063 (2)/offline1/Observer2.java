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
public class Observer2 implements IObserver {
    @Override
    
    public void update(String str)
    {
        System.out.println(str);
    }
}
