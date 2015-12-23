# SwiftJsonToObj

a xcode plugin for json to object write in swift

![image](https://github.com/aotian16/SwiftJsonToObj/raw/master/screenshot/SwiftJsonToObj.png)



click `swiftjson` segment if you use [SwiftJson](https://github.com/aotian16/SwiftJson)

**SwiftJson demo**

``` swift
        let json = JsonParser.p(jsonStr)
        let obj = TopObj(json: json)
        
        if obj.isInitOk {
            print(obj.str)
            print(obj.int)
            print(obj.float)
            print(obj.bool)
            print(obj.arr)
            print(obj.obj!.int1)
            print(obj.obj!.float1)
            print(obj.obj!.bool1)
            print(obj.obj!.str1)
            print(obj.obj!.arr1)
            print(obj.obj!.obj1?.obj2?.objK)
        }
```



**open window from**

Edit -> jsonToObj

**see also**

[SwiftJson](https://github.com/aotian16/SwiftJson)

**License**

MIT