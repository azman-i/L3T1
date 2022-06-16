/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package coffeefactory;

/**
 *
 * @author DELL
 */
public class CoffeeB implements CoffeeInterface{
    
    @Override
    public void addmilk()
    {
        System.out.println("milk added");
    }
     @Override
    public void addCaffein()
    {
        System.out.println("caffein added");
    }
     @Override
    public void addSugar()
    {
        System.out.println("sugar is not added");
    }
    
}
