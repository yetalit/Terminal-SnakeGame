from sys import DLHandle

struct Key:
    var listen: fn() -> Int

    fn __init__(inout self):
        var key_listener = DLHandle('./lib/libkey.so')
        key_listener.get_function[fn(Int32) -> None]('nonblock')(0)
        self.listen = key_listener.get_function[fn() -> Int]('listen_key')
