#include<iostream>
using namespace std;
#include <cstdlib>
#include <ctime>
#include <vector>
#include <algorithm>
#include <cmath>
#include <sstream>
#include <fstream>
//#define Num 7
#define siz 4
struct hash_Val
{
private:
    string str;
    string namestr;
    public:
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
    return str;
}
string hash_Val::getnamestr()
{
    return namestr;
}
void hash_Val::setstr(string str1)
{
    str=str1;
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
    int count=0;
    int collision=0;
    hash_Map(int num);
    ~hash_Map();
    void insert_item(string str,int key,int value,string namestr);
    struct hash_Val* search_item(string str,int select);
    void delete_item(string str,int select);
    void PrintTable();
    int hash_function1(string str);
    int hash_function2(string str);
    int hash_function3(string str);
    void print();
};
struct SymbolTable
{
     struct hash_Map* EnterScope(struct hash_Map* current,int num);
     struct hash_Map* ExitScope(struct hash_Map* root);
     bool InsertCurrent(struct hash_Map* current,string str,int key,int value,string namestr);
     bool RemoveCurrent(struct hash_Map* current,string str,int select);
     struct hash_Val* LookUp(struct hash_Map* current,string str,int select);
     void PrintCurrent(struct hash_Map* current);
     void PrintAll(struct hash_Map* current);
};
void SymbolTable::PrintCurrent(struct hash_Map* current)
{
    cout<<endl<<"ScopeTable       # "<<current->id<<endl<<endl;
    current->print();
}
void SymbolTable::PrintAll(struct hash_Map* current)
{
    while(current!=0)
    {
        cout<<endl<<"ScopeTable       # "<<current->id<<endl<<endl;
        current->print();
        current=current->parent;
    }
}
struct hash_Map* SymbolTable::EnterScope(struct  hash_Map* current,int num)
{
    struct hash_Map* temp=new hash_Map(num);
    temp->id=current->id+1;
    current->next=temp;
    temp->parent=current;
    temp->next=0;
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
bool SymbolTable::InsertCurrent(struct hash_Map* current,string str,int key,int value,string namestr)
{
    current->insert_item(str,key,value,namestr);
}
bool SymbolTable::RemoveCurrent(struct hash_Map* current,string str,int select)
{
    current->delete_item(str,select);
}
struct hash_Val* SymbolTable::LookUp(struct hash_Map* current,string str,int select)
{
  while(current!=0)
  {
      struct hash_Val* temp=current->search_item(str,select);
      if(temp!=0)
        return temp;
      else
        current=current->parent;
  }
  return 0;
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
   //cout<<"hi"<<count%Num<<endl;
    return count%Num;
}
int  hash_Map::hash_function2(string str)
{
    int count=31;
   for (int i = 0; i < str.length(); i++) {
    count = count*31 + str.at(i);
}
    // cout<<"hahha"<<count<<endl;
    return count%Num;
}
void hash_Map::print()
{
    struct hash_Val* p;

    for(int i=0;i<Num;i++)
    {
        p=list[i];
        cout<<i<<" ->   ";
        while(p!=0&&p->getstr().length()!=0)
        {
            cout<<"<"<<p->getstr()<<":"<<p->getnamestr()<<">     ";
            p=p->next;
        }
        cout<<endl;
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
            cout<<i<<"    "<<temp->getstr()<<"    "<<temp->getnamestr()<<endl;
        }
    }
}
void hash_Map::insert_item(string str,int key,int value,string namestr)
{
   //  cout<<"bal"<<endl;
    int key_real=key;
    struct hash_Val* p;
   // cout<<"hi"<<endl;
   struct hash_Val* prev;
   //cout<<key<<endl;
//   cout<<"hi"<<endl;
 //cout<<list[3]->value<<endl;
// cout<<"bal"<<endl;
   if(list[key]->value==-1)
   {
      // cout<<endl<<key<<"            jkk"<<endl;
      //cout<<"bal"<<endl;
         list[key]->next=0;
    list[key]->value=value;
    list[key]->setstr(str);
    list[key]->setnamestr(namestr);
    list[key]->key=key;
    cout<<endl<<"Inserted in Scopetable   #"<<id<<" at position  "<<key<<"  0"<<endl;
    return;
   }
     //cout<<"hi"<<endl;
   //  cout<<"bal"<<endl;
   collision++;
   int y=0;
   p=list[key];
    while((p!=0))
    {
        prev=p;
        if(p->getstr()==str)
        {
            cout<<"already exists"<<endl;
            return;
        }
       p=p->next;
       y++;
    }
    struct hash_Val* temp;
    temp=new hash_Val();
    temp->next=0;
    temp->value=value;
    temp->setstr(str);
    temp->setnamestr(namestr);
    temp->key=key;
    prev->next=temp;
     cout<<endl<<"Inserted in Scopetable   #"<<id<<" at position  "<<key<<"  "<<y<<endl;
   // free(p);
    //free(prev);
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



hash_Map::~hash_Map()
{
    delete[] list;
}



int main()
{
   string line;
     SymbolTable* stable=new SymbolTable();
     hash_Map* root;
     int d;

     struct hash_Map* current;

     	int i = 0;
  int linenum=0;
    int c=0;

	ifstream fin;

	fin.open ("F:\\Level 3 Term 1\\Compiler lab\\Assignment 1\\Assignment 1\\input.txt");
   // cout<<fin.is_open();
	if ( fin.is_open ( ))
	{

		while ( getline ( fin, line ))
		{

		    i=0;
		      vector < string > v;
			stringstream ss ( line );

			while ( getline (ss ,line, ' '))
			{
				v.push_back(line);
			}
			while ( true )
		{
			if ( i == v.size())
			{
				break;
			}

			cout << v [ i ] <<"        ";
			i++;


		}
   // cout<<"iam"<<endl;
    c++;
     if(c==1)
{
             // cout<<"hello"<<v[0]<<endl;
    d=atoi(v[0].c_str());
  //  cout<<"hello"<<endl;/
    root=new hash_Map(d);
    root->parent=0;
     root->next=0;
     root->id=1;
     current=root;
}
else
{
  //  cout<<"hell"<<endl;
	    if(v[0].compare("I")==0)
      {
          //cout<<"hell"<<endl;
         int key=current->hash_function1(v[1]);
        // cout<<"hell"<<endl;
          stable->InsertCurrent(current,v[1],key,current->count,v[2]);
        //  cout<<"hell"<<endl;
     }
     cout<<endl;
     //    cout<<"iam"<<endl;
        if(v[0].compare("L")==0)
        {
            struct hash_Val* temp= stable->LookUp(current,v[1],1);
            if(temp==0)
                cout<<"Not found"<<endl;
        }
        if(v[0].compare("D")==0)
        {
         stable->RemoveCurrent(current,v[1],1);
        }
           // cout<<"iam"<<endl;
    if(v[0].compare("P")==0&&v[1].compare("A")==0&&v.size()>1)
       {
          //cout<<"fuck"<<endl;
          stable->PrintAll(current);
     }
        // cout<<"iam"<<endl;
        if(v[0].compare("P")==0&&v[1].compare("C")==0&&v.size()>1)
        {
           stable->PrintCurrent(current);
        }
         //   cout<<"iam"<<endl;
        if(v[0].compare("S")==0)
        {
             current= stable->EnterScope(current,d);
        }
        if(v[0].compare("E")==0)
        {
       current= stable->ExitScope(root);
        }
   // cout<<"iam"<<endl;
}

		}

	}

}
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
