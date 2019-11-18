def compileModule()
    if RUBY_PLATFORM.include? "mingw32"
        return system('.\\Haskell-Source\\make.bat')
    else
        print "The operating system is #{RUBY_PLATFORM} which is currently not supported"
        return false
    end
end

def main()
    if compileModule()
        print "Module Compiled\n"
    else
        print "Module not compiled"
        return ""
    end

    if RUBY_PLATFORM.include? "mingw32"
        return `.\\module.exe #{ARGV.join(' ')} 2> nul`
    else
        print "The operating system is #{RUBY_PLATFORM} which is currently not supported"
        return ""
    end
end

print main()