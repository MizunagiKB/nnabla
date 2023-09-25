#include <google/protobuf/arenastring.h>
#include <google/protobuf/io/coded_stream.h>
#include <google/protobuf/descriptor.h>
#include <google/protobuf/map.h>

namespace google
{
    namespace protobuf
    {
        const char *const FieldDescriptor::kCppTypeToName[MAX_CPPTYPE + 1] = {
            "ERROR", // 0 is reserved for errors

            "int32",   // CPPTYPE_INT32
            "int64",   // CPPTYPE_INT64
            "uint32",  // CPPTYPE_UINT32
            "uint64",  // CPPTYPE_UINT64
            "double",  // CPPTYPE_DOUBLE
            "float",   // CPPTYPE_FLOAT
            "bool",    // CPPTYPE_BOOL
            "enum",    // CPPTYPE_ENUM
            "string",  // CPPTYPE_STRING
            "message", // CPPTYPE_MESSAGE
        };

        namespace io
        {
            int CodedInputStream::default_recursion_limit_ = 100;
        }

        namespace internal
        {
            void *const kGlobalEmptyTable[kGlobalEmptyTableSize] = {nullptr};

            ExplicitlyConstructedArenaString
                fixed_address_empty_string{};
        }
    }
}
