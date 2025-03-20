from sys import DLHandle, os_is_macos

struct Key:
    var listen: fn() -> Int

    fn __init__(out self):
        var key_listener: DLHandle
        if os_is_macos():
            key_listener = DLHandle('./lib/libkey.dylib')
        else:
            key_listener = DLHandle('./lib/libkey.so')
        key_listener.get_function[fn(Int32) -> None]('nonblock')(0)
        self.listen = key_listener.get_function[fn() -> Int]('listen_key')
