#pragma once

#include "trimi/core/core.hpp"
#include <any>
#include <unordered_map>

namespace arra {

  class Event {
  public:
    Event() = delete;
    explicit Event(EventId type) : m_type(type){};

    template <typename T> void SetParam(EventId id, T value) {
      m_data[id] = value;
    }
    template <typename T> T GetParam(EventId id) { return m_data[id]; }
    

    EventId GetType() const { return m_type; }
    
  private:
    EventId m_type{};
    std::unordered_map<EventId, std::any> m_data{};
};
};
