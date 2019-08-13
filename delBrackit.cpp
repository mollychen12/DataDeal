#include <iostream>
#include <string>
#include <fstream>
//#include <cstddef> //for size_t
using namespace std;

void delBrackit(
                ifstream& fin,
                ofstream& fout)
//int main()
{


    if(!fin.is_open())
  {
    cout<<"the file can not be open"<<endl;
   }
   string s;
    while(getline(fin,s))
    {
      size_t pos = s.find("(");
      while(pos!=string::npos)
      {
          s.erase(pos,1);
          pos = s.find("(");
      }

      pos = s.find(")");
      while(pos!=string::npos)
      {
          s.erase(pos,1);
          pos = s.find(")");
      }
      fout<<s<<endl;
      cout<<s<<endl;
    }

fin.close();

}

int main()
{
    ifstream fin1("U_3_5d.dat");
    ofstream fout1("U_3_5d_out.dat");
    delBrackit(fin1,fout1);

    ifstream fin2("U_3d.dat");
    ofstream fout2("U_3d_out.dat");
    delBrackit(fin2,fout2);

    ifstream fin3("U_4d.dat");
    ofstream fout3("U_4d_out.dat");
    delBrackit(fin3,fout3);
}


//int main(){
////string ur ="1.5";
////ifstream infile("U_"+ur+"d.dat");
////ofstream outfile("U_"+ur+"d_output.dat");
//ifstream infile1("U_3d.dat");
////ifstream infile2("U_4d.dat");
////ifstream infile3("U_3_5d.dat");
//
//ofstream outfile1("U_3d_out.dat");
////ofstream outfile2("U_4d_out.dat");
////ofstream outfile3("U_3_5d_out.dat");
//
//delBrackit(infile1,outfile1);
////delBrackit(infile2,outfile2);
////delBrackit(infile3,outfile3);
//
//}

