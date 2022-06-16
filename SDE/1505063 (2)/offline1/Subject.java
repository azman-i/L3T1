/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package offline;

import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author DELL
 */
public class Subject implements ISubject{
    private String str;
     List<IObserver> observerslist=new ArrayList<IObserver>();
    private String getString()
            {
                return str;
        
    }
    public void setmystring(String str)
    {
        this.str=str;
        notifyObservers(str);
    }
    @Override
     public void register(IObserver o)
     {
         observerslist.add(o);
     }
      public void unregister(IObserver o)
     {
         observerslist.remove(o);
     }
      public void notifyObservers(String str)
      {
          for(int i=0;i<observerslist.size();i++)
              observerslist.get(i).update(str);
      }
}
