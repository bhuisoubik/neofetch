<# Licence : MIT
MIT License

Copyright (c) 2021 Soubik Bhui
	
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
	
The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
	
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
#>

$ntoskrnl_loc = 'C:\Windows\System32\ntoskrnl.exe'
function user_name {
    Write-Host "${env:UserName}" -NoNewline -ForegroundColor Cyan
    Write-Host "@" -NoNewline
    Write-Host "${env:ComputerName}" -ForegroundColor Cyan
}

function draw_line {
    for ($i = 0; $i -lt "${env:UserName}@${env:ComputerName}".Length; $i++) {
        Write-Host '-' -NoNewline
    }
    Write-Host ''
}

function host {
    $host_name = (Get-ComputerInfo).CsModel
    Write-Host "Host " -NoNewline -ForegroundColor Cyan
    Write-Host ": ${host_name}" 
}

function os_name {
    $os_caption = (Get-WmiObject Win32_OperatingSystem).Caption
    Write-Host "OS " -NoNewline -ForegroundColor Cyan
    Write-Host ": ${os_caption}"
}

function uptime {
    $bootT = (Get-CimInstance -ClassName Win32_OperatingSystem).LastBootUpTime
    $currentT = Get-Date
    $uptime = $currentT - $bootT

    $hour = $uptime.Hours.ToString()
    $min = $uptime.Minutes.ToString()
    $days = $uptime.Days.ToString()
    Write-Host "Uptime " -NoNewline -ForegroundColor Cyan
    Write-Host ": $days Days, $hour Hours, $min Minutes"
}

function resolution {
    $vid_mode = (Get-WmiObject -Class Win32_VideoController).VideoModeDescription
    $width = $vid_mode.Split('x')[0]
    $height = $vid_mode.Split('x')[1]
    Write-Host "Resolution " -NoNewline -ForegroundColor Cyan
    Write-Host ": $width x $height" 
}

function cpu {
    $cpu_name = (Get-WmiObject win32_processor).Name
    Write-Host "CPU " -NoNewline -ForegroundColor Cyan
    Write-Host ": $cpu_name" 
}

function gpu {
    $gpu_name = (Get-WmiObject win32_VideoController).Name
    Write-Host "GPU " -NoNewline -ForegroundColor Cyan
    Write-Host ": $gpu_name"
}

function memory {
    $committed_mem = [math]::Floor(((Get-WmiObject  win32_operatingsystem | Select-Object @{L='commit';E={($_.totalvirtualmemorysize - $_.freevirtualmemory)*1KB/0.001GB}}).Commit))
    $available_mem = [math]::Floor((((Get-CIMInstance Win32_OperatingSystem).FreePhysicalMemory)/1000))
    $used_mem = $committed_mem - $available_mem
    $mem = "${used_mem} MB / $committed_mem MB"
    Write-Host "Memory " -NoNewline -ForegroundColor Cyan
    Write-Host ": ${mem}"
}

function terminal_color {
    Write-Host "     " -NoNewline -BackgroundColor Black
    Write-Host "     " -NoNewline -BackgroundColor Red
    Write-Host "     " -NoNewline -BackgroundColor Green
    Write-Host "     " -NoNewline -BackgroundColor Yellow
    Write-Host "     " -NoNewline -BackgroundColor Blue
    Write-Host "     " -NoNewline -BackgroundColor Magenta
    Write-Host "     " -NoNewline -BackgroundColor Cyan
    Write-Host "     " -BackgroundColor White
}

function kernel {
    $version = [System.Diagnostics.FileVersionInfo]::GetVersionInfo($ntoskrnl_loc).FileVersion
    Write-Host "Kernel " -NoNewline -ForegroundColor Cyan
    Write-Host ": $version"
}

function ignore {
    Write-Host ""
}

$specfunc = @(
    $Function:user_name,
    $Function:draw_line,
    $Function:os_name,
    $Function:host,
    $Function:kernel,
    $Function:uptime,
    $Function:resolution,
    $Function:cpu,
    $Function:gpu,
    $Function:memory,
    $Function:ignore,
    $Function:terminal_color,
    $Function:terminal_color,
    $Function:ignore
)

$a = 0
for ($i = 0; ($i -lt 15); $i++) {
    $a = $i
    if($i -gt 6) {
        $a = $i - 1
    }

    if (($i -eq 0) -or ($i -eq 14)) {
        Write-Host "`t`t`t    ###/////////////////`t" -NoNewline -ForegroundColor Blue
        & $specfunc[$a]
    }
    elseif (($i -eq 1) -or ($i -eq 13)) {
        Write-Host "`t   (((//////////  //////////////////////`t" -NoNewline -ForegroundColor Blue
        & $specfunc[$a]
    }
    elseif ($i -eq 7) {
        Write-Host ""
    }
    else {
        Write-Host "`t%///////////////  //////////////////////`t" -NoNewline -ForegroundColor Blue
        & $specfunc[$a]
    }
}
