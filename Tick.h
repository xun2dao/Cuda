#pragma once
#include <iostream>
#include<chrono>
#include<string>
class Timer{
  public:
  Timer(std::string name){
    m_name = name;
    m_start = std::chrono::steady_clock::now();
  }

  ~Timer(){
    m_end = std::chrono::steady_clock::now();
    auto duration = std::chrono::duration_cast<std::chrono::milliseconds>(m_end - m_start);
    std::cout<< m_name <<" takes "<<duration.count()<<"ms"<<std::endl;
  }
  private:
    std::chrono::time_point<std::chrono::steady_clock> m_start;
    std::chrono::time_point<std::chrono::steady_clock> m_end;
    std::string m_name;
};
