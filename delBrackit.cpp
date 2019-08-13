#include <iostream>
#include <string>
#include <fstream>
#include <cstddef> //for size_t
using namespace std;


void delBrackit(
                const std::ifstream& fin,
                std::ofstream& fout
                )

{
    if(!fin.is_open())
  {
    std::cout<<"the file can not be open"<<std::endl;
   }
   std::string s;
    while(getline(fin,s))
    {
      size_t pos = s.find("(");
      while(pos!=string::npos)
      {
          s.erase(pos,1);
          pos = s.find("(");
      }

      pos = s.find(")");
      while(string::npos)
      {
          s.erase(pos,1);
          pos = s.find("(");
      }
      fout<<s<<endl;
    }



}


int main(){
double ur =1.5
ifstream infile("U_"+ur+"d.dat");
ofstream outfile("U_"+ur+"d_output.dat");

delBrackit(infile,outfile);

}

