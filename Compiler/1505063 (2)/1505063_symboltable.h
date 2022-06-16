#include<iostream>
#include <cstdlib>
#include <ctime>
#include <vector>
#include <algorithm>
#include <cmath>
#include <sstream>
#include <fstream>
#include<cstring>
using namespace std;

//#define Num 7
#define siz 4
struct hash_Val
{

   
    public:
     string str;
    string namestr;
    int value;
    int key;

    struct hash_Val* next;
    string getstr();
    void setstr(string str1);
    string getnamestr();
    void setnamestr(string namestr1);


};
string hash_Val::getstr()
{
    cout<<"get set"<<str<<endl;
    return str;
}
string hash_Val::getnamestr()
{
    return namestr;
}
void hash_Val::setstr(string str1)
{
    str=str1;
    cout<<"in set"<<str<<endl;
}
void hash_Val::setnamestr(string namestr1)
{
    namestr=namestr1;
}

struct hash_Map
{

int Num;
 struct hash_Val* list[100];
public:

    int id;
    struct hash_Map* next;
    struct hash_Map* parent;
    int count;
    int collision;
    hash_Map(int num);
    ~hash_Map();
    bool insert_item(string str,int key,int value,string namestr);
    struct hash_Val* search_item(string str,int select);
    void delete_item(string str,int select);
    void PrintTable();
    int hash_function1(string str);
    int hash_function2(string str);
    int hash_function3(string str);
    void print(FILE *f);
};
struct SymbolTable
{
    struct hash_Map* cur;
    SymbolTable(int n)
    {
        cur=new hash_Map(n);
        cur->collision=0;
        cur->count=0;
        cur->id=0;
        cur->parent=0;
        cur->next=0;
    }
     
     bool InsertCurrent(string str,string namestr);
     struct hash_Map* EnterScope(struct hash_Map* current,int num);
      struct hash_Map* ExitScope(struct hash_Map* root);
     void PrintCurrent(FILE *f);
    
};
struct hash_Map* SymbolTable::EnterScope(struct  hash_Map* current,int num)
{
    struct hash_Map* temp=new hash_Map(num);
    temp->id=current->id+1;
    current->next=temp;
    temp->parent=current;
    temp->next=0;
    cur=temp;
    cout<<"New Scope created with id   #"<<temp->id<<endl;
    return temp;

}
struct hash_Map* SymbolTable::ExitScope(struct hash_Map* root)
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
        temp->next=0;
    }
    return temp;
}

void SymbolTable::PrintCurrent(FILE *f)
{
    cout<<endl<<"ScopeTable       # "<<cur->id<<endl<<endl;
    fprintf(f,"ScopeTable     #%d\n\n",cur->id);
    cur->print(f);
}

bool SymbolTable::InsertCurrent(string str,string namestr)
{
    cur->insert_item(str,cur->hash_function1(str),cur->count,namestr);
    return false;
}

hash_Map::hash_Map(int num)
{
    //list=0;

   //list=new hash_Val[Num];
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
int  hash_Map::hash_function1(string str)
{
    int count=0;
    for(int i=0;i<str.length();i++)
    {
        count=count+(str.at(i))*pow(10,(siz-i-1));
     //cout<<count<<endl;

    }
   cout<<"hi"<<count%Num<<"    "<<Num<<endl;
    return count%Num;
}
int  hash_Map::hash_function2(string str)
{
    long long int count=31;
   for (int i = 0; i < str.length(); i++) {
    count = count*31 + str.at(i);
}
    
    return count%Num;
}
void hash_Map::print(FILE *f)
{
    struct hash_Val* p;

    for(int i=0;i<Num;i++)
    {
        p=list[i];
        cout<<i<<" ->   ";
        fprintf(f,"%d  ->  ",i);
        while(p!=0&&p->str.length()!=0)
        {
         
            cout<<"<"<<p->str<<":"<<p->namestr<<">     ";
            fprintf(f,"<%s:%s>",strdup(p->str.c_str()),strdup(p->namestr.c_str()));
            p=p->next;
        }
        cout<<endl;
        fprintf(f,"\n");
        //cout<<list[i]->key<<"          "<<list[i]->value<<"          "<<list[i]->str<<endl;
    }
}
int  hash_Map::hash_function3(string str)
{
   int count=0;
    for(int i=0;i<str.length();i++)
    {
        count=count+(str.at(i))*pow(11,(3+i-1));
}
   return count%Num;

}

void hash_Map::PrintTable()
{
    for(int i=0;i<Num;i++)
    {
        struct hash_Val* temp;
        temp=list[i];
        while(temp!=0)
        {
            cout<<i<<"    "<<temp->str<<"    "<<temp->namestr<<endl;
        }
    }
}
bool hash_Map::insert_item(string str,int key,int value,string namestr)
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
   
    list[key]->namestr=namestr;
    list[key]->key=key;
    cout<<endl<<"Inserted in Scopetable   #"<<id<<" at position  "<<key<<"  0"<<endl;
    
    return true;
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
           
            return false;
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
    temp->namestr=namestr;
    temp->key=key;
    prev->next=temp;
     cout<<endl<<"Inserted in Scopetable   #"<<id<<" at position  "<<key<<"  "<<y<<endl;
    return true;
   //cout<<"hi"<<endl;
    //cout<<key<<"             "<<value<<endl;
    //cout<<list[key].key<<"      "<<list[key].value<<"            "<<list[key].str<<endl;
}
struct hash_Val*  hash_Map::search_item(string str,int select)

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
}

void hash_Map::delete_item(string str,int select)
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







