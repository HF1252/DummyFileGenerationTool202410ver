@echo off
setlocal enabledelayedexpansion

:: --- ユーザー入力 ---
set /p sizeInput="ファイルサイズを入力してください。 (数字のみ)（例：2）: "
set /p unit="バイトの種類を選択してください。 (項目：B, KB, MB, GB, TB): "

:: --- 単位をバイトに変換 ---
set "size=%sizeInput%"
if /i "%unit%"=="B" set "unit=1"
if /i "%unit%"=="KB" set "unit=1024"
if /i "%unit%"=="MB" set "unit=1048576"
if /i "%unit%"=="GB" set "unit=1073741824"
if /i "%unit%"=="TB" set "unit=1099511627776"

:: --- GUIでファイル名と拡張子を選択 ---
set "defaultFileName=Dummy.txt"
for /f "delims=" %%I in ('powershell -command "[System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms') | Out-Null; $f = New-Object System.Windows.Forms.SaveFileDialog; $f.Title = 'ファイル名を選択'; $f.FileName = '%defaultFileName%'; $f.Filter = 'Text files (*.txt)|*.txt|CSV files (*.csv)|*.csv|PDF files (*.pdf)|*.pdf|All files (*.*)|*.*'; if ($f.ShowDialog() -eq 'OK') { $f.FileName }"') do set "filepath=%%I"

:: --- PowerShellでバイトサイズに変換してファイル作成 ---
powershell -command "fsutil file createnew '%filepath%' ([int64]::Parse('%size%') * [int64]::Parse('%unit%'))"
if errorlevel 1 (
    echo エラー: ファイルを作成できませんでした。容量オーバーまたは無効なパスの可能性があります。
    pause
    exit /b 1
)

:: --- 結果出力 ---
echo %filepath% に空のファイルを作成しました。
pause