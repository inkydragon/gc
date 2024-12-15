#include <iostream>
#include <iterator>
#include <regex>
#include <string>


int main() {
    /*
        D:\jl\julia\base\version.jl
        const VERSION_REGEX = r"^
            v?                                      # prefix        (optional)
            (\d+)                                   # major         (required)
            (?:\.(\d+))?                            # minor         (optional)
            (?:\.(\d+))?                            # patch         (optional)
            (?:(-)|                                 # pre-release   (optional)
            ([a-z][0-9a-z-]*(?:\.[0-9a-z-]+)*|-(?:[0-9a-z-]+\.)*[0-9a-z-]+)?
            (?:(\+)|
            (?:\+((?:[0-9a-z-]+\.)*[0-9a-z-]+))?    # build         (optional)
            ))
        $"ix
        125,9:     m = match(VERSION_REGEX, String(v)::String)
    */

    // 拼接多个正则表达式模式
    std::string vre = "";
    vre += R"(v?)";   // prefix        (optional)
    vre += R"((\d+))";  // major         (required)
    vre += R"((?:\.(\d+))?)";  // minor         (optional)
    vre += R"((?:\.(\d+))?)";  // patch         (optional)
    vre += R"()";  // 
    vre += R"()";  // 
    vre += R"()";  // 
    vre += R"()";  // 
    std::regex version_regex(vre);

    // std::regex version_regex(R"(^v?(\d+)(?:\.(\d+))?(?:\.(\d+))?(?:-([a-z][0-9a-z-]*(?:\.[0-9a-z-]+)*))?(?:\+((?:[0-9a-z-]+\.)*[0-9a-z-]+))?$)");

    // 测试字符串
    std::string version = "v1.2.3-alpha+001";

    // 匹配版本号
    std::smatch matches;
    if (std::regex_match(version, matches, version_regex)) {
        std::cout << "匹配成功!" << std::endl;
        std::cout << "主版本号: " << matches[1] << std::endl;
        if (matches[2].matched)
            std::cout << "次版本号: " << matches[2] << std::endl;
        if (matches[3].matched)
            std::cout << "修订版本号: " << matches[3] << std::endl;
        if (matches[4].matched)
            std::cout << "预发行版本: " << matches[4] << std::endl;
        if (matches[5].matched)
            std::cout << "构建元数据: " << matches[5] << std::endl;
    } else {
        std::cout << "匹配失败!" << std::endl;
    }

    return 0;
}

// g++ -O3 re.cpp -o re && ./re
