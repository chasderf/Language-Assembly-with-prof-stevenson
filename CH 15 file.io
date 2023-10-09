Sequential access files

Sequential access file IO is pretty self explanatory. You open file and read sequentially from the top
of the file to the bottom. The process of reading and writing to a sequential access file is not that
much different than reading or writing from the console. There are three things you should know
1. Open the file - use the CreateFile function which creates a new file if it doesn’t exist or opens an
existing file
2. Read or Write to the file - use the ReadFile function or the WriteFile function to read and write
data to and from a file
3. Close the file - use the CloseHandle function to close the file. It is important to close the file as
soon as you are finished reading or writing. Files left open can become corrupt

Opening a file
To open a file you use the CreateFileA function. This function opens an existing file or creates a new
one if the file doesn’t exist. The CreateFileA function has this prototype

CreateFileA PROTO,
lpFileName: PTR BYTE,
dwDesiredAccess: DWORD,
dwShareMode : DWORD,
lpSecurityAttributes: DWORD,
dwCreationDisposition: DWORD
dwFlagsAndAttributes : DWORD,
hTemplateFile : DWORD

If this function succeeds a valid file handle will be returned in the EAX register. This will be needed
for all file processing.

The parameters are probably going to need some explanation. The following table describes them:

CreateFile Parameters
Parameter description
IpFileName pointer to a null terminated string that contains the name of the file.
Can contain path also

Opening a file
To open a file you use the CreateFileA function. This function opens and existing file or creates a
new one if the file doesn’t exist.

The CreateFileA function has the following prototype:

CreateFileA Proto,
IlFileName: PTR BYTE,
DwDesiredAccess: DWORD,
DwShareMode: DWORD,
IpSecurityAttributes : DWORD,
DwCreationDisposition: DWORD,

DwFlagsAndAttributes: DWORD,
HTemplateFile: DWORD

If this function succeeds a valid file handle will be returned in the EAX register. This will be needed
for all file processing.

The parameters are probably going to need some explanation. The following table describes them:

CreateFile Parameters
Parameter description
IpFileName pointer to a null terminated string that contains the name of
the file. Can contain path also
DwDesiredAccess the value specified whether to open the file for reading or writing
DwShareMode controls the ability for multiple programs to access the file while it is open
IpSecurityAttributes points to a security structure controlling security rights
DwCreationDisposition specifies what action to take when the file exists or doesn’t exist
DwFlagsAndAttributes holds the flags specifying these archives attributes such as archive,
encrypted hidden, normal, system and temporary
HTemplateFile contains an optional handle to a template file that supplies file attributes
and extended attributes for the file being created. This value should be
set to zero when not in use

The dwDesiredAccess parameter is typically set to one of the following windows constants
• 800 0000h - generic read mode. This is defined as GENERIC_READ in the Windows API

• 400 0000h - generic write mode. This is defined as GENERIC_WRITE in the windows API

It would probably be best to define the values as GENERIC_READ and GENERIC_WRITE instead of
hard coding the values

The dwCreationDisposition parameter is used to specify what you mode you want to open the file
in. In windows these are defined as constrains

File disposition values and description
Constant value description
CREATE_NEW 1 Creates a new file, only if it doesn’t already exist
if the specified file exists, the function fails and the last-
error code is set to ERROR_FILE_EXISTS (80)

If the specified file doesn’t exist and is a valid path to a
writable location, a new file is created

CREATE_ALWAYS 2 creates a new file, always
if the specified file exists and is writable, the function
overwrites the file, the function succeeds, and last-error
code is set to ERROR_ALREADY_EXISTS(183)

If the specified file doesn’t exist and is not a valid path, a
new file is created, the function succeeds,

and the last-error code is set to zero

OPEN_EXISTING 3 Opens a file or device, only if it exists

if the specified file or device doesn’t exist, the function
fails and the last-error code is set to
ERROR_FILE_NOT_FOUND (2)

OPEN_ALWAYS 4 Open a file, always.

if the specified file exists, the function succeeds
and the last-error code is set to ERROR_ALREADY_EXISTS (183)

If the specified file doesn’t exist and is a valid path to a
writable location, the function creates a file
and the last-error code is set to zero

TRUNCATE_EXISTING 5 Opens a file and truncates it so that its size is zero bytes,
and if it exists

if the specified file doesn’t exist, the function fails and the
last-error code is set to ERROR_FILE_NOT_FOUND (2)

The calling process must open the file with the
GENERIC_WRITE bit set as part of the dwDesiredAccess
parameter

The dwFlagsAndAttributes are used to specify the attributes you want to set on the file. The most
common is : FILE_ATTRIBUTE_NORMAL which has a value of hex 80

CloseFileHandle Function
This will be the mode we will use for this class. For more information about attributes use...

This is a pretty simply thing to do you simply invoke the Windows CloseHandle function, it has the
following prototype :

CloseHandle PROTO,
hObject :DWORD

hObject is the handle to the file that was returned in the EAX register when the CreateFile function
was called. If this function fails a value of 0 will be returned in the EAX register. Any non-zero value
returned in the EAX register means the function succeeded

WriteFile function
This function is used to write data to a file. The WriteFile function has the following prototype:

WriteFile PROTO,
hHandle: DWORD,
IpBuffer : PTR BYTE,
nNumberOfBytesToWrite : DWORD,
pNumberOfBytesWritten : PTR DWORD,
IpOverlapped : PTR DWORD

The definition for the parameters are defined bellow

WriteFile Parameters
Parameter description

hHandle the handle to the open file that was returned in the EAX by a
call to the CreateFile function

IpBuffer a NULL terminated string of character to be written to the file

nNumberOfBytesToWrite the number of bytes you would like to write to the file

pNumberOfBytesWritten the actual number of bytes that were written to the file

IpOverlapped A pointer to an overlapped structure is required if the hFile
parameter was opened with FILE_FLAG_OVERLAPPED,
otherwise this parameter can be NULL

When writing to a file it is always best to check the number of bytes written. If for some reason this
value is 0 then you’d probably have an error.

GetLastError function
The GetLastError function will return the last error generated. If you are writing to a file and the
number of bytes written is 0 then you may want to call this function

GetLastError PROTO ; get most recent error return value

When called this function will return an error code in the EAX register

Reading from a file
If you understand how to write to a file then reading from a file is pretty straight forward.
You use the ReadFile function that is part of the windows API.

ReadFile PROTO,

hHandle : DWORD
lpBuffer : PTR BYTE,
numberOfBytesToRead: DWORD,
pNumberOfBytesRead: PTR DWORD,
lpOverlapped: PTR DWORD

The parameters are as follows
• hHandle - this is the handle returned in the EAX from the call to CreateFile
• IpBuffer - this is a pointer to an array of BYTES to hold the data read from the file
• NumberOfBytesToRead - this is the maximum number of bytes you want read from the file
• IpOverlapped - is the same as WriteFile. We can set it to 0 or NULL

Changes to CreateFileA
When opening a file for reading there are a couple of changes that need to be made to the
CreateFileA function:

INVOKE CreateFileA, EDX, GENERIC_READ, NULL, NULL,
OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL

The first is that we want GENERIC_READ not GENRIC_WRITE. We also want OPEN_EXISTING
instead of CREATE_ALWAYS
