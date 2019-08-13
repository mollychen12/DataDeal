#include <fstream>
#include <sstream>
#include <iostream>
#include <iomanip>
#include <cmath>
#include <vector>
#include <string>

#include<regex>//regulation expression lib

void read_data_col(
                   //const char* myfilename,
                   std::ifstream&  fin,
                   const int col,
                   std::vector<std::string>& col_data)
{
    //std::string filename = myfilename;
    //std::ifstream fin("data.txt");

    if(!fin.is_open())
    {
        std::cout<<"Unable to open the file"<<std::endl;
        system("pause");
        exit(1);
    }
    std::vector<std::string> vec_str;
    std::string temp;
   // double length_line;

    while(getline(fin,temp))
    {
        //length_line = temp.size();
        vec_str.push_back(temp);
    }

    //std::vector<double>  col_data_tmp;
    for(auto iter = vec_str.begin();iter!= vec_str.end();iter++)
    {
        std::istringstream is(*iter);
        std::string s;
        int  pam = 0;
        while(is >> s)
        {
            if(pam == col)//
            {
               // double data = atof(s.c_str());
               // col_data.push_back(data);
               //if(s.empty())  {s = "0";}
               col_data.push_back(s);
            }
            pam++;
        }
    }
//         for(int i=0;i<col_data.size();++i)
//    {
//        std::cout<<col_data[i]<<std::endl;
//    }
}

void delIncompleteLine( std::ifstream& infile,
                        std::ofstream& outfile)
{
std::string s;
std::vector<std::string> vec_str;
double length_average;
int temp_sum=0;

while(getline(infile,s))
{
   vec_str.push_back(s);
}
for(int i=0;i<=vec_str.size();++i)
{
    temp_sum += vec_str[i].size();
    //std::cout<<"str_size["<<i<<"] = "<<vec_str[i].size()<<std::endl;
}
  length_average = temp_sum/vec_str.size();
  //std::cout<<"length_average"<<length_average<<std::endl;

for(auto iter = vec_str.begin();iter!= vec_str.end();++iter)
{
    //if(abs((*iter).size()-(*(iter+1)).size())>18)
    //if(( (*(iter+1)).size() - (*iter).size())>20)
    //  if(abs((*iter).size()-length_average+5) >10
           if((*iter).size()<(length_average-10))
      {
           vec_str.erase(iter);
           iter--;
      }//note:the line above the aim line will always be delete
}
for(int i=0;i<vec_str.size();++i)
{
    //std::cout<<vec_str[i]<<std::endl;
    outfile<<vec_str[i]<<std::endl;
}

}

std::string searchInQuota(std::string& source,
                     std::vector<std::string>& vec_result_str,
                     const int n_i)
{
    //define a regulation expression
    std::regex pattern("\"(.*?)\"");

    auto pattern_begin = std::sregex_iterator(source.begin(),
                                              source.end(),
                                              pattern);
    auto pattern_end = std::sregex_iterator();
    //declare results vars
    std::match_results<std::string::const_iterator> rerResult;
    //std::smatch rerResult; the line is equale to above line

    //match
    //bool bValid = regex_match(s,rerResult,pattern);
    regex_search(source,rerResult,pattern);
    for(std::sregex_iterator i = pattern_begin;i!=pattern_end;++i)
    {
     std::string str_rerResult = rerResult.str();
     vec_result_str.push_back(str_rerResult);
    }

return rerResult[n_i];
}


std::string searchNumbers(std::string& source,
                        std::vector<std::string>&  vec_num,
                         const int n_i )
{
    std::regex pattern("[-+]?[0-9]*\.?[0-9]+");
    auto number_begin=std::sregex_iterator(source.begin(),source.end(),pattern);
    auto number_end = std::sregex_iterator();
    std::smatch number;
    std::regex_search(source,number,pattern);
    for(std::sregex_iterator i = number_begin;i!= number_end;++i)
    {
        std::string number_str = number.str();
        vec_num.push_back(number_str);
    }
       return vec_num[n_i];
}

void dealData(std::vector<std::string>& name,
              std::vector<std::string>& power_temp_c,
              std::vector<std::string>& power,
              std::ofstream& outfile)
{
       std::string power_temp_low_t,power_temp_units,
                   power_temp_high_t,power_units;

       //extract solid_material;
       std::string solid_material;
       std::vector<std::string> vec_solid_material;

         for(int i =0;i<power_temp_c.size();++i)
         {
           std::vector<std::string> temp;
           solid_material = searchInQuota(power_temp_c[i],temp,0);
           vec_solid_material.push_back(solid_material);

           //delete the "solid_material"
           size_t pos = power_temp_c[i].find(solid_material);
           while(pos!=std::string::npos)
           {
               power_temp_c[i].erase(pos,solid_material.size()-1);
               pos = power_temp_c[i].find(solid_material);
           }
           pos = power[i].find(solid_material);
            while(pos!=std::string::npos)
           {
               power[i].erase(pos,solid_material.size());
               pos = power[i].find(solid_material);
           }

           //replace the $C_
           std::string new_word = "$Cco*";
           pos = power_temp_c[i].find("$C");
         //while((pos = power_temp_c[i].find("$C"))!=std::string::npos)
           //{
               power_temp_c[i].replace(pos,new_word.size(),new_word);
           //}
           pos = power[i].find("$C");
        // while((pos = power[i].find("$C"))!=std::string::npos)
          // {
               power[i].replace(pos,new_word.size(),new_word);
           //}
         }

           //extract number
           std::string numbers_string;
           std::vector<std::string> vec_numbers_string;
           for(int i=0;i<power_temp_c.size();++i)
           {
               std::vector<std::string> temp;
               numbers_string = searchNumbers(power_temp_c[i],temp,0);
               vec_numbers_string.push_back(numbers_string);
               //std::cout<<numbers_string<<"\n";
           }

           //replace the number and string
           for(int i = 0;i<power.size();++i)
           {
               //the initial position of the string and numbers
               size_t pos_num_l = power[i].find(vec_numbers_string[i]);
               size_t pos_string_l = power[i].find("$F");
               size_t pos_num_r = power[i].rfind(vec_numbers_string[i]);
               size_t pos_string_r = power[i].find("$F*$Cco*Tref");

                //-the pointer is array as
               //pos_num_l pos_string_l pos_num_r pos_string_r

               //replace from back to forth
               power[i].replace(pos_string_r,13,vec_numbers_string[i]);
               power[i].replace(pos_num_r,vec_numbers_string[i].size(),"$F*$Cco*$Tref");
               power[i].replace(pos_string_l,2,vec_numbers_string[i]);
               power[i].replace(pos_num_l,vec_numbers_string[i].size(),"$F");

//              std::cout<<"pos_string_r = " <<pos_string_r<<"\n";
//              std::cout<<"pos_num_r = " <<pos_num_r<<"\n";
//              std::cout<<"pos_string_l = " <<pos_string_l<<"\n";
//              std::cout<<"pos_num_l = " <<pos_string_l<<"\n";

            }

          //change the position of number and string in power_temp_c
            for(int i =0;i<power_temp_c.size();++i)
            {
             size_t pos_num = power_temp_c[i].find(vec_numbers_string[i]);
             size_t pos_string = power_temp_c[i].find("$Cco*$F");
             //-the array of is
             //pos_num pos_string

            power_temp_c[i].replace(pos_string,7,vec_numbers_string[i]);
            power_temp_c[i].replace(pos_num,vec_numbers_string[i].size(),"$Cco*$F");
//            std::cout<<"pos_string =" <<pos_string<<"\n";
//            std::cout<<"pos_num =" <<pos_num<<"\n";
            }

          //change the name
         for(int i =0;i<name.size();++i){
         if(name[i].find("DOWN")!=std::string::npos)
           {
               name[i].insert(4,"_");
           }
         if(name[i].find("Geom")!=std::string::npos)
           {
               name[i].insert(4,"-1_");
           }
         }

         //delete the quota of solid_material
         for(int i=0;i<vec_solid_material.size();++i){
                      vec_solid_material[i].erase(0,1);
                      vec_solid_material[i].erase(vec_solid_material[i].size()-1,1);
                  }

        power_temp_low_t= "$lowT";
        power_temp_units= "C";
        power_temp_high_t= "$highT";
        power_units= "W";

      for(int i= 0;i<name.size();++i)
         {
             std::cout<<name[i]<<","<<vec_solid_material[i]<<","
                      <<"temperature"<<","<<power[i]<<","
                      <<power_temp_c[i]<<","<<power_temp_low_t<<","
                      <<power_temp_units<<","<<power_temp_high_t<<","
                      <<power_temp_units<<","<<power_units<<"\n";
             outfile<<name[i]<<","<<vec_solid_material[i]<<","
                      <<"temperature"<<","<<power[i]<<","
                      <<power_temp_c[i]<<","<<power_temp_low_t<<","
                      <<power_temp_units<<","<<power_temp_high_t<<","
                      <<power_temp_units<<","<<power_units<<"\n";
         }

}

 int main()
{
        std::ifstream inifile("1.txt");
        std::ofstream delLine("2.txt");
        delIncompleteLine(inifile,delLine);

        std::ofstream outfile1("poly.csv");
        std::ofstream outfile2("block.csv");

        std::ifstream my_fin0("2.txt");
        std::ifstream my_fin1("2.txt");
        std::ifstream my_fin2("2.txt");
        std::ifstream my_fin3("2.txt");
        const int col_0 =0;
        const int col_1 =1;
        const int col_2 =2;
        const int col_3 =3;
        std::vector<std::string> data_col0,data_col1,
                                 data_col2,data_col3;
       read_data_col(my_fin0,col_0,data_col0);
       read_data_col(my_fin1,col_1,data_col1);
       read_data_col(my_fin2,col_2,data_col2);
       read_data_col(my_fin3,col_3,data_col3);

// for(int i=0;i<data_col0.size();i++)
//    {
//        std::cout<<std::left<<std::setfill(' ')
//        <<std::setw(14)<<data_col0[i]
//        <<std::setw(40)<<data_col1[i]
//        <<std::setw(70)<<data_col2[i]
//        <<std::setw(3)<<data_col3[i]
//                  <<'\n';
//
//
//    }

std::vector<std::string> name_block,name_prism,
                        power_temp_c_block,power_temp_c_prism,
                        power_block,power_prism;

for(int i = 0;i<data_col0.size();++i)
   {
    if((data_col0[i].find("Geom")!=std::string::npos)
       ||(data_col0[i].find("DOWN")!=std::string::npos))
    {
        // data which output to poly
        if(data_col0[i].find("ter")!=std::string::npos)
        {
        name_prism.push_back(data_col0[i]);
        power_temp_c_prism.push_back(data_col1[i]);
        power_prism.push_back(data_col2[i]);
        }
          //data which output to block
        else
        {
        name_block.push_back(data_col0[i]);
        power_temp_c_block.push_back(data_col1[i]);
        power_block.push_back(data_col2[i]);
        }
   }
    continue;
    }

  dealData(name_prism,power_temp_c_prism,power_prism,outfile1);
  dealData(name_block,power_temp_c_block,power_block,outfile2);

}
