import WinSDK

// ประกาศฟังก์ชัน CreateFileW
@_silgen_name("CreateFileW")
func createFileW(
    lpFileName: UnsafePointer<wchar_t>?,
    dwDesiredAccess: DWORD,
    dwShareMode: DWORD,
    lpSecurityAttributes: LPSECURITY_ATTRIBUTES?,
    dwCreationDisposition: DWORD,
    dwFlagsAndAttributes: DWORD,
    hTemplateFile: HANDLE
) -> HANDLE

// การแปลงสตริงเป็น wchar_t*
func toWideString(_ string: String) -> UnsafePointer<wchar_t> {
    let wideString = string.utf16.map { UInt16($0) }
    return wideString.withUnsafeBufferPointer { $0.baseAddress! }
}

// ค่าคงที่จาก Windows SDK (ค่าตัวอย่าง ต้องแทนที่ค่าที่เหมาะสม)
let GENERIC_WRITE: DWORD = 0x40000000
let CREATE_ALWAYS: DWORD = 2
let FILE_ATTRIBUTE_NORMAL: DWORD = 0x00000080

// ใช้ UnsafeMutableRawPointer สำหรับ INVALID_HANDLE_VALUE
let INVALID_HANDLE_VALUE: HANDLE = UnsafeMutableRawPointer(bitPattern: -1)!

// การใช้ฟังก์ชัน CreateFileW
let fileName = "example.txt"
let wideFileName = toWideString(fileName)
let fileHandle = createFileW(
    lpFileName: wideFileName,
    dwDesiredAccess: GENERIC_WRITE,
    dwShareMode: 0,
    lpSecurityAttributes: nil,
    dwCreationDisposition: CREATE_ALWAYS,
    dwFlagsAndAttributes: FILE_ATTRIBUTE_NORMAL,
    hTemplateFile: INVALID_HANDLE_VALUE
)

// ตรวจสอบการเปิดไฟล์
if fileHandle == INVALID_HANDLE_VALUE {
    let errorCode = GetLastError()
    print("Failed to create file. Error code: \(errorCode)")
} else {
    print("File created successfully!")
    // อย่าลืมปิด handle เมื่อเสร็จสิ้นการใช้งาน
    CloseHandle(fileHandle)
}
