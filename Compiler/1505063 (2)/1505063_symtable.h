
#include<iostream>
#include <cstdlib>
#include <ctime>
#include <vector>
#include <algorithm>
#include <cmath>
#include <sstream>
#include <fstream>
using namespace std;
extern ofstream llog;
extern vector<string> param_list;
extern int param_no;
//#define Num 7
#define siz 4
struct infor
{
string real;
string name;
string getreal()
{
return real;

}
infor(string a)
{
real=a;

}
infor(string a,string b)
{
real=a;
name=b;
}
};
struct hash_Val
{
public:
    string type;
    bool isfunction;
    bool isarray;
    int sval;
    string code;
    string tempvar;
    string funcret;
    string str;
    string namestr;
    int p_no;
    vector<string> param_type;
    public:
    int value;
    int key;
  
    struct hash_Val* next;
  hash_Val()
{

}
  hash_Val(string a,string b)
{
  str=a;
  namestr=b;
}
hash_Val(string a,string ttype,bool isfunc)
{
  str=a;
type=ttype;
  isfunction=isfunc;
}

hash_Val(string a)
{
str=a;
}
vector<string> ret_param_list()
{
   return param_type;
}
int getparamno()
{
  return p_no;
}
    string getstr()
{
return str;
}
bool getarray()
{
  return isarray;
}
string gettype()
{
return type;
}
    void setstr(string str1)
{
str=str1;
}
    string getnamestr()
{
return namestr;
}
    void setnamestr(string namestr1)
{
namestr=namestr1;
}


};


struct hash_Map
{

 struct hash_Val* list[100];
public:
   int Num;
    bool isfu;
    int id;
    struct hash_Map* next;
    struct hash_Map* parent;
    int count;
    int collision;
    hash_Map(int num)
{
    //list=0;

   //list=new hash_Val[Num];
  collision=0;
  count=0;
  id=0;
  parent=0;
  next=0;
  Num=num;
    for(int i=0;i<Num;i++)
        {
            list[i]= new hash_Val();
            //list[i]=0;
            list[i]->value=-1;
        list[i]->next=0;
        list[i]->key=-2;
   //  cout<<list[i]->value<<endl;
        }
}

    void insert_item(string str,int key,int value,string namestr,string type,bool isfunc,string funcret,bool isarray)
{
      cout<<str<<endl;
   //  cout<<"bal"<<endl;
    int key_real=key;

    struct hash_Val* p;
   // cout<<"hi"<<endl;
   struct hash_Val* prev;
   //cout<<key<<endl;
//   cout<<"hi"<<endl;
 //cout<<list[3]->value<<endl;

cout<<list[key]->value<<endl;

   if(list[key]->value==-1)
   {
      // cout<<endl<<key<<"            jkk"<<endl;

         list[key]->next=0;
    list[key]->value=value;

    list[key]->str=str;
     list[key]->type=type;
  list[key]->isfunction=isfunc;
    list[key]->namestr=namestr;
    list[key]->funcret=funcret;
    list[key]->isarray=isarray;
     list[key]->param_type=param_list;
      if(isfunc==true)
      {
     list[key]->param_type=param_list;
     list[key]->p_no=param_no;
     // llog<<"paramno"<<param_no;
}
    list[key]->key=key;
    cout<<endl<<"Inserted in Scopetable   #"<<id<<" at position  "<<key<<"  0"<<endl;

    return ;
   }
     //cout<<"hi"<<endl;
   //cout<<"bal"<<endl;
   collision++;
   int y=0;
   p=list[key];





    while((p!=0))
    {
        prev=p;
          cout<<p->str<<endl;

        if(p->str==str)
        {
            cout<<"already exists"<<endl;

            return;
        }
       p=p->next;

       y++;
    }
   // cout<<"bal"<<endl;
    struct hash_Val* temp;
    temp=new hash_Val();
    temp->next=0;
    temp->value=value;
    temp->str=str;
     temp->type=type;
     temp->isfunction=isfunc;
    temp->namestr=namestr;
temp->funcret=funcret;
    temp->isarray=isarray;
  temp->p_no=param_no;
   temp->param_type=param_list;
    temp->key=key;
    prev->next=temp;
     cout<<endl<<"Inserted in Scopetable   #"<<id<<" at position  "<<key<<"  "<<y<<endl;
    return;
   //cout<<"hi"<<endl;
    //cout<<key<<"             "<<value<<endl;
    //cout<<list[key].key<<"      "<<list[key].value<<"            "<<list[key].str<<endl;
//   //  cout<<"bal"<<endl;
//    int key_real=key;
//    struct hash_Val* p;
//   // cout<<"hi"<<endl;
//   cout<<"hahah"<<endl;
//   struct hash_Val* prev;
//    cout<<list[key]->value<<endl;
//   //cout<<key<<endl;
////   cout<<"hi"<<endl;
// //cout<<list[3]->value<<endl;
//// cout<<"bal"<<endl;
//   if(list[key]->value==-1)
//   {
//      // cout<<endl<<key<<"            jkk"<<endl;
//      cout<<"bal"<<endl;
//         list[key]->next=0;
//    list[key]->value=value;
//    list[key]->setstr(str);
//    list[key]->setnamestr(namestr);
//    list[key]->key=key;
//    cout<<endl<<"Inserted in Scopetable   #"<<id<<" at position  "<<key<<"  0"<<endl;
//    return;
//   }
//     //cout<<"hi"<<endl;
//   //  cout<<"bal"<<endl;
//   cout<<"hahah"<<endl;
//   collision++;
//   int y=0;
//   p=list[key];
//    while((p!=0))
//    {
//        prev=p;
//        if(p->getstr()==str)
//        {
//            cout<<"already exists"<<endl;
//            return;
//        }
//       p=p->next;
//       y++;
//    }
//    cout<<"hahah"<<endl;
//    struct hash_Val* temp;
//    temp=new hash_Val();
//    temp->next=0;
//    temp->value=value;
//    temp->setstr(str);
//    temp->setnamestr(namestr);
//    temp->key=key;
//    prev->next=temp;
//     cout<<endl<<"Inserted in Scopetable   #"<<id<<" at position  "<<key<<"  "<<y<<endl;
//   // free(p);
//    //free(prev);
//   //cout<<"hi"<<endl;
//    //cout<<key<<"             "<<value<<endl;
//    //cout<<list[key].key<<"      "<<list[key].value<<"            "<<list[key].str<<endl;
//
}
    struct hash_Val* search_item(string str,int select)
{
     int fa_key;
    if(select==1)
   fa_key=hash_function1(str);
  if(select==2)
       fa_key=hash_function2(str);
  if(select==3)
       fa_key=hash_function3(str);
  int dummy=fa_key;
  //fa_key=5;
  struct hash_Val* p;
  p=list[fa_key];
  int y=0;
  while(p!=0)
  {
      if(p->getstr()==str)

      {
          cout<<"Found in ScopeTable #   "<<id<<" at position    "<<fa_key<<"      "<<y<<endl;
       return p;
      }
      p=p->next;
         y++;
  }
  return 0;
//    int fa_key;
//    struct hash_Val *temp=0;
//    if(select==1)
//   fa_key=hash_function1(str);
//  if(select==2)
//       fa_key=hash_function2(str);
//  if(select==3)
//       fa_key=hash_function3(str);
//  int dummy=fa_key;
//  //fa_key=5;
//  struct hash_Val* p;
//  p=list[fa_key];
//  int y=0;
//  while(p!=0)
//  {
//      if(p->getstr()==str)
//
//      {
//          cout<<"Found in ScopeTable #   "<<id<<" at position    "<<fa_key<<"      "<<y<<endl;
//       return p;
//      }
//      p=p->next;
//         y++;
//  }
//   cout<<"Not found"<<endl;
//   cout<<Num<<endl;
//  return temp;
}
    void delete_item(string str,int select)
{
    struct hash_Val* temp=search_item(str,select);
    if(temp==0)
        cout<<"Not Found"<<endl;
    else{
    int fa_key;
    if(select==1)
   fa_key=hash_function1(str);
  if(select==2)
       fa_key=hash_function2(str);
  if(select==3)
       fa_key=hash_function3(str);
     int dummy=fa_key;
     //cout<<fa_key<<endl;

    struct hash_Val* temp;
     struct hash_Val* prev;
     //dummy=5;
    temp=list[dummy];
    int y=0;
   // cout<<"hi"<<endl;
   //struct listNode *temp, *prev ;
	//temp = list ; //start at the beginning
	while (temp != 0)
	{
		if (temp->getstr() == str) break ;
		prev = temp;
		temp = temp->next ; //move to next node
		y++;
	}
	if (temp == 0) return ; //item not found to delete
	if (temp == list[dummy]) //delete the first node
	{
	    //cout<<"jcnsdk"<<endl;
		list[dummy] = list[dummy]->next ;
		free(temp) ;
	}
	else
	{
	    //cout<<"jcnsdk1"<<endl;
		prev->next = temp->next ;
		free(temp);
	}
	cout<<"Deleted entry at   "<<fa_key<<"   "<<y<<"   from current ScopeTable"<<endl<<endl<<endl<<endl;
	return  ;
    }

     }
    void PrintTable()
{
    for(int i=0;i<Num;i++)
    {
        struct hash_Val* temp;
        temp=list[i];
        while(temp!=0)
        {
            cout<<i<<"    "<<temp->getstr()<<"    "<<temp->getnamestr()<<endl;
        }
    }
}
    int hash_function1(string str)
{
    int count=0;
    cout<<"hi"<<endl;

    for(int i=0;i<str.length();i++)
    {
        count=count+(str.at(i))*pow(10,(siz-i-1));
     cout<<count<<endl;

    }
     cout<<"hhhh"<<endl;
   cout<<this->Num<<endl;
cout<<count%(this->Num)<<endl;
   cout<<"hhhh"<<endl;
    return count%(this->Num);
    }
    int hash_function2(string str)
{
    int count=31;
   for (int i = 0; i < str.length(); i++) {
    count = count*31 + str.at(i);
}
}
    int hash_function3(string str)
{
   int count=0;
    for(int i=0;i<str.length();i++)
    {
        count=count+(str.at(i))*pow(11,(3+i-1));
}
   return count%Num;

}

    void print()
{
    struct hash_Val* p;
     cout<<"sdckdcsdcoiclksdcld"<<endl;
    for(int i=0;i<Num;i++)
    {
        p=list[i];
        cout<<i<<" ->   ";
        llog<<i<<" ->   ";
        while(p!=0&&p->getstr().length()!=0)
        {
            cout<<"<"<<p->getstr()<<":"<<p->getnamestr()<<">     ";
            llog<<"<"<<p->getstr()<<":"<<p->getnamestr()<<">     ";
            p=p->next;
        }

        llog<<endl;
          cout<<endl;
        //cout<<list[i]->key<<"          "<<list[i]->value<<"          "<<list[i]->str<<endl;
    }
}
};
struct SymbolTable
{
public:
     
     struct hash_Map* cur;
     struct hash_Map* root;
     int  msize;
    SymbolTable(int n)
    {
        cur=new hash_Map(n);


        root=cur;
        msize=n;
    }

   void setisfu(bool t)
{
    cur->isfu=t;
}

   void setCurrentParent()
{
  cur=cur->parent;
}
  bool getisfu()
{
  return cur->isfu;
}
     struct hash_Map* EnterScope()
{
    struct hash_Map* temp=new hash_Map(msize);
    temp->id=cur->id+1;
    cout<<cur->id<<temp->id<<endl;
    cur->next=temp;
    temp->parent=cur;
    temp->next=0;
    cur=temp;
    cout<<"New Scope created with id   #"<<temp->id<<endl;
    return temp;

}
  struct hash_Val* searchinroot(string str)
{
 return root->search_item(str,1);
}
     struct hash_Map* ExitScope()
{
struct hash_Map* temp;
    struct hash_Map* root1;
    root1=root;
    temp=0;
    while(root1->next!=0)
    {
        temp=root1;
        root1=root1->next;
    }
    if(temp==0)
    {
        root=0;
    }
    else
    {
        cout<<"ScopeTable with id     "<<root1->id<<"    removed"<<endl;
        llog<<"ScopeTable with id     "<<root1->id<<"    removed"<<endl;
         temp->next=0;
    }
    cur=temp;
    return temp;
}
     bool InsertCurrent(string str,string namestr,string type,bool isfunc,string funcret,bool isarray)
{
cout<<cur->Num<<endl;
    int key=cur->hash_function1(str);
    cout<<"hello1"<<endl;
    cur->insert_item(str,key,cur->count,namestr, type, isfunc,funcret,isarray);
return false;
}
     bool RemoveCurrent(string str,int select)
{
    cur->delete_item(str,select);
return false;
}
     struct hash_Val* LookUp(string str,int select)
{
    struct hash_Map* temp1;
    temp1=cur;
  while(temp1!=0)
  {
      struct hash_Val* temp=temp1->search_item(str,select);
      if(temp!=0)
        return temp;
      else
        temp1=temp1->parent;
        }
  return 0;
}
struct hash_Val* look(string str,int select)
{
struct hash_Map* temp1;
    temp1=cur;
return temp1->search_item(str,select);

}
     void PrintCurrent()
{
    
    cout<<endl<<"ScopeTable       # "<<cur->id<<endl<<endl;
    cur->print();
}
     void PrintAll()
{
      cout<<"hellsjdkcsdcsdk"<<endl;
 
    
    cout<<"hellsjdkcsdcsdk"<<endl;
    struct hash_Map* temp;
    temp=cur;
    while(temp!=0)
    {
        cout<<endl<<"ScopeTable       # "<<temp->id<<endl<<endl;
        llog<<endl<<"ScopeTable       # "<<temp->id<<endl<<endl;
        temp->print();
        //fprintf(f,"hello");
        temp=temp->parent;
      llog<<"hhhhhhhh"<<endl;
    }
  llog<<"hhhhhhhh2"<<endl;
}
};







//int main()
//{
//   string line;
//
//     hash_Map* root;
//     int d;
//      SymbolTable* stable;
//     struct hash_Map* current;
//
//     	int i = 0;
//  int linenum=0;
//    int c=0;
//
//	ifstream fin;
//
//	fin.open ("F:\\Level 3 Term 1\\Compiler lab\\Assignment 1\\Assignment 1\\input1.txt");
//   // cout<<fin.is_open();
//	if ( fin.is_open ( ))
//	{
//
//		while ( getline ( fin, line ))
//		{
//
//		    i=0;
//		      vector < string > v;
//			stringstream ss ( line );
//
//			while ( getline (ss ,line, ' '))
//			{
//				v.push_back(line);
//			}
//			while ( true )
//		{
//			if ( i == v.size())
//			{
//				break;
//			}
//
//			cout << v [ i ] <<"        ";
//			i++;
//
//
//		}
//   // cout<<"iam"<<endl;
//    c++;
//     if(c==1)
//{
//             // cout<<"hello"<<v[0]<<endl;
//    d=atoi(v[0].c_str());
// stable=new SymbolTable(d);
//  //  cout<<"hello"<<endl;/
//}
//else
//{
//  //  cout<<"hell"<<endl;
//	    if(v[0].compare("I")==0)
//      {
//          //cout<<"hell"<<endl;
//         //int key=current->hash_function1(v[1]);
//        cout<<stable->cur->Num<<endl;
//          stable->InsertCurrent(v[1],v[2]);
//        //  cout<<"hell"<<endl;
//     }
//     cout<<endl;
//     //    cout<<"iam"<<endl;
//        if(v[0].compare("L")==0)
//        {
//              cout<<stable->cur->Num<<endl;
//             stable->LookUp(v[1],1);
//              cout<<stable->cur->Num<<endl;
//        }
//        if(v[0].compare("D")==0)
//        {
//         stable->RemoveCurrent(v[1],1);
//        }
//           // cout<<"iam"<<endl;
//    if(v[0].compare("P")==0&&v[1].compare("A")==0&&v.size()>1)
//       {
//          //cout<<"fuck"<<endl;
//          stable->PrintAll();
//     }
//        // cout<<"iam"<<endl;
//        if(v[0].compare("P")==0&&v[1].compare("C")==0&&v.size()>1)
//        {
//           stable->PrintCurrent();
//        }
//         //   cout<<"iam"<<endl;
//        if(v[0].compare("S")==0)
//        {
//             current= stable->EnterScope();
//        }
//        if(v[0].compare("E")==0)
//        {
//       current= stable->ExitScope();
//        }
//   // cout<<"iam"<<endl;
//}
//
//		}
//
//	}
//
//}/*/*
//struct hash_Map* a=new hash_Map();
//a->insert_item("aaaa",5,30);
//a->insert_item("aaan",5,31);
//
//a->insert_item("bbbb",6,40);
//a->delete_item("aaan",5);
////cout<<a->search_item("bbbb",1)<<endl;
//cout<<a->search_item("aaan",1)<<endl;
//
//a->print();
/* hash_Map* m=new hash_Map();
  hash_Map* m1=new hash_Map();
  hash_Map* m2=new hash_Map();*/
//  m->insert_item("abba",20,30);
//  m->insert_item("abaa",20,500);
//  cout<<m->search_item("abaa")<<endl;
 /*int flag=0;
  vector<string>  first;
	string abcs= "abcdefghijklmnopqrstuvwxyz" ;

	while(flag<Num)
	{
	    	string a;
	    for(int i = 0;i<size;i++)
	{
		a.push_back(abcs[rand()%abcs.length()]) ;
	}
	flag++;

	if(find(first.begin(), first.end(), a) != first.end()==false)
	{
	    first.push_back(a);
	    m->insert_item(a,m->hash_function1(a),m->count);
	  //cout<<a<<"     ";
	    //cout<<m->hash_function1(a)<<endl;
	  //  cout<<"value"<<m1->hash_function2(a)<<endl;
	      m1->insert_item(a,m1->hash_function2(a),m1->count);
	        m2->insert_item(a,m2->hash_function3(a),m2->count);
	m->count++;
	m1->count++;
	m2->count++;
	}
	}
//m->print();
//cout<<endl<<endl;
//m2->print();
//cout<<count<<endl;
cout<<"collision   for hash function 1         "<<m->collision<<endl;
cout<<"collision    for hash function 2        "<<m1->collision<<endl;
cout<<"collision    for hash function 3        "<<m2->collision<<endl;
int select,fkk=0 ;
string cs= "abcdefghijklmnopqrstuvwxyz" ;
while(fkk<3)
{flag=0;
clock_t t;
t=clock();
	while(flag<Num)
	{
	    	string a;
	    for(int i = 0;i<size;i++)
	{
		a.push_back(cs[rand()%abcs.length()]) ;
	}
	if(fkk==0)
	m->search_item(a,1);
	if(fkk==1)
	m1->search_item(a,2);
        if(fkk==2)
        m2->search_item(a,3);
	flag++;
	}
t=clock()-t;
cout <<"It took me seconds for hash function"<<fkk+1<<"            "<<((float)t)/CLOCKS_PER_SEC<<endl;
fkk++;
}

//cout<<m->search_item(str1)<<endl;
while(1)
    {
        //printf("1. Add edge. \n");
        cin>>select;
       cout<<"1.reinsert  2.serach    3.delete"<<endl;

        int ch;
     cin>>ch;
        if(ch==1)
        {
            string str;
            cin>>str;
            if(select==1)
            {m->insert_item(str,m->hash_function1(str),m->count);
             m->count++;
              m->print();}
            if(select==2)
                   {m1->insert_item(str,m1->hash_function2(str),m1->count);
                    m1->count++;
                     m1->print();}
                   if(select==3)
               {m2->insert_item(str,m2->hash_function3(str),m2->count);
               m2->count++;
                m2->print();
               }


        }
        else if(ch==2)
        {
         string str;
         cin>>str;
         if(select==1)
         {cout<<m->search_item(str,select)<<endl;
         // m->print();
          }
         if(select==2)
            {cout<<m1->search_item(str,select)<<endl;
             //m->print();
             }
         if(select==3)
            {cout<<m2->search_item(str,select)<<endl;
        // m->print();
        }
        }
        else if(ch==3)
        {
              string str;
              cin>>str;
            if(select==1)
        {
            m->delete_item(str,select);
             m->print();
        }
         if(select==2)
           {m1->delete_item(str,select);
            m1->print();
           }
         if(select==3)
         {m2->delete_item(str,select);
          m2->print();
          }

        }
    }

}*/
