@echo off
setlocal enabledelayedexpansion

:: --- ���[�U�[���� ---
set /p sizeInput="�t�@�C���T�C�Y����͂��Ă��������B (�����̂�)�i��F2�j: "
set /p unit="�o�C�g�̎�ނ�I�����Ă��������B (���ځFB, KB, MB, GB, TB): "

:: --- �P�ʂ��o�C�g�ɕϊ� ---
set "size=%sizeInput%"
if /i "%unit%"=="B" set "unit=1"
if /i "%unit%"=="KB" set "unit=1024"
if /i "%unit%"=="MB" set "unit=1048576"
if /i "%unit%"=="GB" set "unit=1073741824"
if /i "%unit%"=="TB" set "unit=1099511627776"

:: --- GUI�Ńt�@�C�����Ɗg���q��I�� ---
set "defaultFileName=Dummy.txt"
for /f "delims=" %%I in ('powershell -command "[System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms') | Out-Null; $f = New-Object System.Windows.Forms.SaveFileDialog; $f.Title = '�t�@�C������I��'; $f.FileName = '%defaultFileName%'; $f.Filter = 'Text files (*.txt)|*.txt|CSV files (*.csv)|*.csv|PDF files (*.pdf)|*.pdf|All files (*.*)|*.*'; if ($f.ShowDialog() -eq 'OK') { $f.FileName }"') do set "filepath=%%I"

:: --- PowerShell�Ńo�C�g�T�C�Y�ɕϊ����ăt�@�C���쐬 ---
powershell -command "fsutil file createnew '%filepath%' ([int64]::Parse('%size%') * [int64]::Parse('%unit%'))"
if errorlevel 1 (
    echo �G���[: �t�@�C�����쐬�ł��܂���ł����B�e�ʃI�[�o�[�܂��͖����ȃp�X�̉\��������܂��B
    pause
    exit /b 1
)

:: --- ���ʏo�� ---
echo %filepath% �ɋ�̃t�@�C�����쐬���܂����B
pause