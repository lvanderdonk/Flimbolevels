
// --------------------------------------------------------------------- #
//       FCG              /      TLC           /         RWE             #
// FLASH CRACKING GROUP  /  THE LIGHT CIRCLE  /  RADWAR ENTERPRISES      #
//                                           1941 <-> 1985 <-> 2015      #
// --------------------------------------------------------------------- #
//                                                                       #
//                        A N D   N O W                                  #
//         G R A N D D A D D Y   C O D I N G   S E N I O R S             #
//                                                                       #
// fcg/rwe/tlc/gcs    source preservation project (rpp)                  #
//                                    done by -duke!         /\          #
//                                                          /  \         #
//               #########                                 /\   \        #
// created using C64ReAsm3 on March 26th, 2018            /  \   \       #
//               #########                               /\   \   \      #
// prj: 'LevelEd' for Laurens van der Donk / BWB        /  \   \   \     #
//   reverse engineered by duke!                       /____\___\___\    #
//                                                                       #
// prj. no.: 118                                                         #
//                                                                       #
// target source format: kick assembler v3.27 by Mads Nielsen            #
//                                                                       #
// --------------------------------------------------------------------- #

//http://sta.c64.org/cbm64krnfunc.html

//http://sta.c64.org/cbm64mem.html



		.pc = $0801 "Basic Upstart"
		:BasicUpstart(start) // 10 sys $6000
		.pc = $6000 "Basic startup Jmp Code"
start:
		jmp LevelEd

// ------------------------------------------------------------------------------------- | 
.var aCurrentCharNo = $2b
.var aPointerCharset = $2e
.var aPointerCharsetL = $2e
.var aPointerCharsetH = $2f
.var aCharEditPixelX = $32
.var aCharEditPixelY = $33

.var aTmpA = $34
.var aTmpX = $35
.var aTmpY = $36
.var aTmpKey = $37
.var aCursorScreenPosX= $3A
.var aCursorScreenPosY = $3B
.var aLevelCharEditMode = $53
.var aScreenPosXL = $44
.var aScreenPosXH = $45
.var aLineNumber = $46
.var aForBackMode = $55
.var aUpDownMode = $56
.var aHideForGroundMode = $50

.var aTmpBackCol = $57 
.var aTmpMultiCol1 = $58
.var aTmpMultiCol2 = $59
.var pCharSet = $66      // +$67
.var aTmpReadDir =$FB

.var aLevel = $2000
.var aLevelBackground = aLevel+$1c20
.var aBaseColors = $44B8
.var aUpperMultiCol1 = aBaseColors
.var aUpperMultiCol2 = aBaseColors+1
.var aUpperBackCol = aBaseColors+2
.var aLowerMultiCol1 = aBaseColors+3
.var aLowerMultiCol2 = aBaseColors+4
.var aLowerBackCol = aBaseColors+5

.var aTmpCharcolors = $4700
.var aTmpBlockToPaste = $5000

.var aScreen = $c000
.var aCharcolors = $c400
.var aBumpdata = $c500
.var aTmpCharColorsForBump = $c600

.var aSprite1 = $C700
.var aSprite2 = $c740
.var aCharset = $c800
.var aRomCharset = $d000
.var aColorMemory = $d800
.var aCopyRomCharset = $f000

.var aCopyCharset =$e000
.var aCharMulticol1 = aCharset+$07e8
.var aCharMulticol2 = aCharset+$07f0
.var aCharcol = aCharset+$07f8
.var aCharEmpty = aCharset

.var ForegroundLevelLength = 7200  //$1c20
.var BackgroundLevelLength = 2200  //$0898
.var LevelLength = ForegroundLevelLength+BackgroundLevelLength  //$24B8

LevelEd:
		jsr 	ClearAllLevelData
		sei									
		lda		#$33						
		sta		$01
//CopyRomCharset						
		ldy		#$07							
		lda		#>aRomCharset						
		sta		RomCharset+2
		lda		#>aCopyRomCharset							
		sta		CopyRomCharset+2						
		ldx		#$00
RomCharset:
!Loop:
		lda		$ff00,x					
CopyRomCharset:
		sta		$ff00,x						
		inx									
		bne		!Loop-			
		inc		RomCharset+2						
		inc		CopyRomCharset+2						
		dey									
		bpl		!Loop-
//End CopyRomCharset				
		lda		#$37						
		sta		$01						
		nop									
//Create necessary characters for editor in charset
		ldy		#$07							
FillEditChars:
		lda		#$55							
		sta		aCharMulticol1,y						
		lda		#$AA							
		sta		aCharMulticol2,y						
		lda		#$FF							 
		sta		aCharcol,y						 
		lda		#$00							
		sta		aCharEmpty,y						
		sta		$F000,y						
		dey									
		bpl		FillEditChars							
		ldy		#$00							
		tya								
!Loop:
		sta		$FE00,y						
		sta		$FEC0,y					
		iny									 
		bne		!Loop-
//Create Sprites						 
		ldy		#$3F						
!Loop:
		lda		DataSprite1,y					
		sta		aSprite1,y						
		lda		DataSprite2,y						
		sta		aSprite2,y						
		dey									
		bpl		!Loop-
//End create sprites
		lda		#$00							
		sta		aCurrentCharNo							
		sta		$3C						
		sta		aCharEditPixelY							
		sta		aCharEditPixelX							 
		sta		aCursorScreenPosY					
		sta		aCursorScreenPosX					
		sta		aTmpKey						 
		sta		$40							 
		sta		$41							 
		sta		aScreenPosXL							
		sta		aScreenPosXH				 
		sta		$4D							
		sta		$4E							 
		sta		$4F							
		sta		$D020							
		sta		aForBackMode						
		sta		aUpDownMode							
		sta		BgIsSet						
		lda		#$01							
		sta		aHideForGroundMode							
ResumeEditor:
		lda		#$04							
		sta		$DD00							
		sei								
		lda		#$02							
		sta		$D018							 
		lda		#$D8							
		jsr		InitSystemvalues						
		lda		#$35							
		sta		$01							
		nop									
		nop									
		lda		#$1B							 
		sta		$D011							
		lda		#$01							
		sta		$D01A							
		sta		$D019							
		lda		#<Irq1						
		sta		$FFFE							
		lda		#>Irq1						
		sta		$FFFF							
		lda		#<Nmi						
		sta		$FFFA							
		lda		#>Nmi						
		sta		$FFFB							
		lda		#$2D							
		sta		$D012							
		cli									
		jsr		ClearEditorScreen						
		lda		aUpDownMode						
		jsr		SetUpstairsDownstairs						
		ldx		#$00							
		stx		$D017						
		stx		$54
//Draw Characterset and Colors							
!Loop:
		txa									
		sta		$C2D0,x					
		tay									
		lda		aCharcolors,y						
		sta		$D9D0,x						
		inx									
		bne		!Loop-						
CharEdit:
		lda		#$01							
		sta		aLevelCharEditMode						
		jsr		ShowLevel						
		jsr		DrawCharEditSquare						
		jsr		DrawBigCharEdit						
		jsr		SetColorCurChar						
LoopCharEdit:
		lda		#$03							
		sta		YposLetterSprites					
		ldx		#<tCharEdit						
		ldy		#>tCharEdit					
		jsr		PrintText						
		lda		aTmpKey			 			
		ldx		#$25							
!NextKeyboardOption:
		cmp		KeyOptionsCharEdit,x						
		beq		KeyPressed						
		dex									
		bpl		!NextKeyboardOption-					
		bmi		LoopCharEdit						
KeyPressed:
		txa								
		asl									
		tax								
		lda		FunctionsCharEdit,x						
		sta		FPCharEdit+1					
		lda		FunctionsCharEdit+1,x						
		sta		FPCharEdit+2						 
FPCharEdit:
		jsr		$ff00
		jsr		DrawBigCharEdit						
		jsr		SetColorCurChar						
		jmp		LoopCharEdit						
// ------------------------------------------------------------------------------------- | 
KeyOptionsCharEdit:
		.byte		$53 //s CharLeft
		.byte		$44 //d CharRight
		.byte		$45 //e CharUp
		.byte		$58 //x CharDown
		.byte 		$9D //CursorLeft	CharEditPixelXMin
		.byte 		$1D //CursorRight	CharEditPixelXPlus
		.byte		$91 //CursorUp		CharEditPixelYMin
		.byte		$11 //CursorDown	CharEditPixelYPlus
		.byte		$87 //F5   CharCol+1
		.byte 		$34 //4    MultiCol1UpNext
		.byte		$35 //5    MultiCol2UpNext
		.byte		$36 //6    BackColUpNext
		.byte		$31	//1    SetPixelMulti1
		.byte		$32	//2    SetPixelMulti2
		.byte		$33 //3    SetPixelCol
		.byte		$20 //Space ClearPixel
		.byte		$D8 //X 	Clear editchar
		.byte		$CC //L 	LoadLevel
		.byte		$D3 //S 	SaveLevel
		.byte		$D1 //Q 	FillEditCharCol1
		.byte		$D7 //W 	FillEditCharCol2
		.byte		$C5 //E 	FillEditCharCol3
		.byte		$85 //F1	GotoLevelEdit
		.byte		$52 //r		RepeatKeys
		.byte		$39	//9 BackCol Down
		.byte		$37	//7 MultiCol1 Down
		.byte		$38	//8 MultiCol2 Down
		.byte		$55	//u UpDownMode
		.byte		$43	//c Copy characters in charedit
		.byte		$8B //F6  CharCol-1
		.byte		$88 //F7  ShowDirectory
		.byte		$B8 //CTRL + u Fill unused chars
		
// ------------------------------------------------------------------------------------- | 
FunctionsCharEdit:
            .word       CharLeft
            .word       CharRight
            .word       CharUp
            .word       CharDown
            .word       CharEditPixelXMin
            .word       CharEditPixelXPlus
            .word       CharEditPixelYMin
            .word       CharEditPixelYPlus
            .word       CharColNext
            .word       MultiCollUp1Next
            .word       MultiCollUp2Next
            .word       BackCollUpNext
            .word       SetPixelMulti1
            .word       SetPixelMulti2
            .word       SetPixelCol
            .word       ClearPixel
            .word       ClearEditChar
            .word       LoadLevel
            .word       SaveLevel
            .word       FillEditCharCol1
            .word       FillEditCharCol2
            .word       FillEditCharCol3
            .word       GotoLevelEdit
            .word       RepeatKeys
            .word       BackCollLowerNext
            .word       MultiCollLower1Next
            .word       MultiCollLower2Next
            .word       SwitchUpStairsDownStairs
            .word       CopyCharEdit
            .word       CharColPrev
            .word       ShowDirectory
            .word       FillUnusedChars
// ------------------------------------------------------------------------------------- | 
FillUnusedChars:
		ldx		#<tPleaseWait						
		ldy		#>tPleaseWait						
		jsr		PrintText						
		lda		aCurrentCharNo							
		sta		RestoreCharNo+1						
		ldx		#$01							
!Loop:
		lda		#<aLevel							
		sta		LevelChar+1					
		lda		#>aLevel					
		sta		LevelChar+2
!NextLevelChar:						
LevelChar:
		cpx		$ff00							
		bne		NextLevelChar						
NextChar:
		inx									
		stx		aCurrentCharNo						
		cpx		#$FC						
		bne		!Loop-						
RestoreCharNo:
		lda		#$00							
		sta		aCurrentCharNo							
		rts									
// ------------------------------------------------------------------------------------- | 
NextLevelChar:
		inc		LevelChar+1						
		bne		!Cont+						
		inc		LevelChar+2						
!Cont:
		lda		LevelChar+1						
		cmp		#<LevelLength							
		bne		!NextLevelChar-						
		lda		LevelChar+2						
		cmp		#>LevelLength							
		bne		!NextLevelChar-						
		jsr		ClearUnusedChar						
		jmp		NextChar						
// ------------------------------------------------------------------------------------- | 
ClearUnusedChar:
		txa									
		ldy		#$00						
		sty		PCharset+2					
		asl									
		rol		PCharset+2						
		asl									
		rol		PCharset+2						
		asl									
		rol		PCharset+2						
		sta		PCharset+1						
		lda		PCharset+2					
		adc		#>aCharset							
		sta		PCharset+2						
		ldy		#$07							
		lda		#$00
PCharset:							
!Loop:
		sta		$ff00,y						
		dey									
		bpl		!Loop-						
		rts									
// ------------------------------------------------------------------------------------- | 
SwitchUpStairsDownStairs:
		lda		aUpDownMode						
		eor		#$01							
		sta		aUpDownMode							
// ------------------------------------------------------------------------------------- | 
SetUpstairsDownstairs:
		asl									
		asl									 
		asl									 
		tay									 
		ldx		#$00							
!Loop:
		lda		tEditorText,y						
		sta		tUpOrDownMode1,x						
		sta		tUpOrDownMode2,x						
		sta		tUpOrDownMode3,x						
		inx									
		iny									
		cpx		#$08							
		bne		!Loop-						
		rts								
// ------------------------------------------------------------------------------------- | 
GotoLevelEdit:
		pla									
		pla									
		lda		#$00						
		sta		aLevelCharEditMode						
		jmp		LevelEdit						
// ------------------------------------------------------------------------------------- | 
GotoCharEdit:
		pla									
		pla									
		jmp		CharEdit						
// ------------------------------------------------------------------------------------- | 
LevelEdit:
		lda		#$00							
		sta		$3C							
		sta		PasteState+1					
		jsr		ShowLevel					
LoopLevelEdit:
		lda		aForBackMode						
		beq		ContForGroundEdit						 
		lda		#$0A							
		sta		YposLetterSprites						
		ldx		#<tBackgroundEdit						
		ldy		#>tBackgroundEdit						
		jsr		PrintText						
		jmp		ContBackGroundEdit						
// ------------------------------------------------------------------------------------- | 
ContForGroundEdit:
		lda		#$03							
		sta		YposLetterSprites						
		ldx		#<tForgroundEdit							 
		ldy		#>tForgroundEdit							
		jsr		PrintText						
ContBackGroundEdit:
		lda		aTmpKey							 
		ldx		#$29							
!NextKeyboardOption:
		cmp		KeyOptionsLevelEdit,x						
		beq		!KeyPressed+			
		dex									
		bpl		!NextKeyboardOption-						
		bmi		LoopLevelEdit						
!KeyPressed:
		txa									
		asl									 
		tax									
		lda		FunctionsLevelEdit,x						 
		sta		FPLevelEdit+1						
		lda		FunctionsLevelEdit+1,x					 
		sta		FPLevelEdit+2						
FPLevelEdit:
		jsr		$ff00				 
		jsr		ShowLevel					
		jmp		LoopLevelEdit						
// ------------------------------------------------------------------------------------- |
//LevelEdit 
KeyOptionsLevelEdit:
		.byte		$53 //s CharLeft
		.byte		$44 //d CharRight
		.byte		$45 //e CharUp
		.byte		$58 //x CharDown
		.byte		$34 //4 MultiCol1UpNext
		.byte		$35 //5 MultiCol2UpNext
		.byte		$36 //6 BackCollUpNext
		.byte		$CC //L LoadLevel
		.byte		$D3 //S SaveLevel
		.byte		$21 // ClearCharInLecel
		.byte		$85 //f1 GotoCharEdit
		.byte 		$9D //CursorLeft		CursorLeft	
		.byte 		$1D //CursorRight		CursorRight	
		.byte		$91 //CursorUp			CursorUp		
		.byte		$11 //CursorDown		CursorDown	
		.byte		$8D //Shift+Return		GotoCharOfLevel
		.byte		$0D //Return			PlaceCharInlevel		
		.byte		$D8 //Shift + x			BlockCopyStart
		.byte		$C3 //Shift	+ c			BlockCopyEnd
		.byte		$D6 //Shift + v			BlockCopyPaste
		.byte		$57 //w					HideForeGround
		.byte		$52 //r					RepeatKeys
		.byte		$3E	//>					ScrollLeft
		.byte		$3C //<					ScrollRight
		.byte		$86 //f3				SwitchForBackMode
		.byte		$2E //.					ScrollLeft40
		.byte		$2C //,					ScrollRight40
		.byte		$39 //9					BackCollDownNext
		.byte		$37 //7					MultiCol1DownNext
		.byte		$38 //8					MultiCol2DownNext
		.byte		$55 //u					SwitchUpStairsDownStairs
		.byte		$C2 //SHift b			Bumpdata
		.byte		$88 //f7				ShowDirectory
		.byte		$B8 //Ctrl + u			Fill unused chars
		.byte		$AA //Ctrl + n			BackgroundCharStart
		.byte		$A7 //Ctrl + m			


// ------------------------------------------------------------------------------------- | 
FunctionsLevelEdit:
		.word		CharLeft	
		.word		CharRight
		.word		CharUp					
		.word		CharDown					
		.word		MultiCollUp1Next				
		.word		MultiCollUp2Next						
		.word		BackCollUpNext		
		.word		LoadLevel				 
		.word		SaveLevel					
		.word		ClearCharInLevel						 
		.word		GotoCharEdit						
		.word		CursorLeft					
		.word		CursorRight						
		.word		CursorUp						
		.word		CursorDown				
		.word		GotoCharOfLevel					
		.word		PlaceCharInlevel			
		.word		BlockCopyStart						
		.word		BlockCopyEnd						
		.word		BlockCopyPaste			 			
		.word		HideForeGround					
		.word		RepeatKeys					
		.word		ScrollLeft				
		.word		ScrollRight					
		.word		SwitchForBackMode						
		.word		ScrollLeft40					
		.word		ScrollRight40					
		.word		BackCollLowerNext				
		.word		MultiCollLower1Next				
		.word		MultiCollLower2Next				
		.word		SwitchUpStairsDownStairs					
		.word		Bumpdata					
		.word		ShowDirectory				 			
		.word		FillUnusedChars					
		.word		BackgroundCharStart						
		.word		BackgroundCharEnd						

Shifts:
			.byte		$02, $04, $06
CurrentShift:
            .byte       $00
ShiftIndex:
            .byte       $00
// ------------------------------------------------------------------------------------- | 
BackgroundCharStart:
		lda		aCurrentCharNo						
		sta		BgCharNo					 
ContBgChars:
		ldx		#<tEndBackgroundChars						
		ldy		#>tEndBackgroundChars							
		jsr		PrintText						 
		lda		aTmpKey							
		cmp		#$53		//s					
		beq		BgCharLeft						 
		cmp		#$44		//d					 
		beq		BgCharRight						 
		cmp		#$45		//e					 
		beq		BgCharUp						 
		cmp		#$58		//x					
		beq		BgCharDown						
		cmp		#$0D		//enter					
		bne		ContBgChars						
		lda		aCurrentCharNo							
		sec									
		sbc		BgCharNo						
		sta		BgLength						
		lda		#$01							
		sta		BgIsSet						
		lda		#$00							
		sta		POrgSetH+1					
		lda		BgCharNo						
		asl									
		rol		POrgSetH+1						
		asl									
		rol		POrgSetH+1					
		asl									
		rol		POrgSetH+1						
		sta		POrgSetL+1						 
		lda		POrgSetH+1						 
		adc		#>aCopyCharset							
		sta		POrgSetH+1						
		rts									
// ------------------------------------------------------------------------------------- | 
BgCharLeft:
		jsr		CharLeft2						
		jmp		ContBgChars						
// ------------------------------------------------------------------------------------- | 
BgCharRight:
		jsr		CharRight2						
		jmp		ContBgChars						
// ------------------------------------------------------------------------------------- | 
BgCharUp:
		jsr		CharUp2						
		jmp		ContBgChars						
// ------------------------------------------------------------------------------------- | 
BgCharDown:
		jsr		CharDown2						
		jmp		ContBgChars						
// ------------------------------------------------------------------------------------- | 
BackgroundCharEnd:
		lda		BgIsSet						
		bne		ShiftChars						
		ldx		#<tBackgroundError							
		ldy		#>tBackgroundError				
		jsr		PrintText						
		jmp		!WaitForSpace+						
// ------------------------------------------------------------------------------------- | 
ShiftChars:
		lda		#$08							
		sta		$D018							
		jsr		CreateCopyCharset						
		inc		ShiftIndex					
		ldx		ShiftIndex					
		cpx		#$03							
		bne		ContShift						
		ldx		#$00							
ContShift:
		stx		ShiftIndex						
		lda		Shifts,x						
		sta		CurrentShift					 
!NextCharSet:
		ldy		#$00
!Loop:						
POrgSetL:
		lda		#$00						
		sta		pCharSet
									
POrgSetH:		
        lda		#$E0							
		sta		pCharSet+1							
		clc									
		php									
		ldx		BgLength						
!NextChar:
		plp									
		lda		(pCharSet),y						
		ror									
		sta		(pCharSet),y						
		php									
		lda		pCharSet							
		clc									
		adc		#$08						
		sta		pCharSet						
		lda		pCharSet+1				
		adc		#$00							
		sta		pCharSet+1							
		dex									
		bpl		!NextChar-						
		plp									
		iny									 
		cpy		#$08							
		bne		!Loop-						
		dec		CurrentShift						 
		bne		!NextCharSet-					
!WaitForSpace:
		lda		$DC01							
		cmp		#$EF							
		bne		!WaitForSpace-						
		lda		#$02							
		sta		$D018							
		rts									
// ------------------------------------------------------------------------------------- | 
BgIsSet:
		.byte		$00							
BgCharNo:
		.byte		$00							
BgLength:
		.byte		$00							
// ------------------------------------------------------------------------------------- | 
CreateCopyCharset:
		ldy		#$00							
		ldx		#$07							
		lda		#>aCharset							
		sta		OrgCharset+2						
		lda		#>aCopyCharset							 
		sta		CopyCharset+2						 
		ldy		#$00
OrgCharset:							
!Loop:
		lda		$ff00,y						 
CopyCharset:
		sta		$ff00,y						
		iny									
		bne		!Loop-						 
		inc		OrgCharset+2						
		inc		CopyCharset+2						
		dex									
		bpl		!Loop-					
		rts									
// ------------------------------------------------------------------------------------- | 
BlockCopyStart:
		lda		aForBackMode							
		beq		ContBlockCopyStart						
		jmp		CopyInBackground						
// ------------------------------------------------------------------------------------- | 
ContBlockCopyStart:
		jmp		CopyInForeGround						
// ------------------------------------------------------------------------------------- | 
BlockCopyEnd:
		lda		aForBackMode						
		beq		ContBlockCopyEnd						
		jmp		BlockCopyEndInBackGround					
// ------------------------------------------------------------------------------------- | 
ContBlockCopyEnd:
		jmp		BlockCopyEndInForeGround						
// ------------------------------------------------------------------------------------- | 
BlockCopyPaste:
		lda		aForBackMode							
		beq		ContBlockCopyPaste						
		jmp		PasteInBackGround						
// ------------------------------------------------------------------------------------- | 
ContBlockCopyPaste:
		jmp		PasteInForeGround						
// ------------------------------------------------------------------------------------- | 
CopyStartCharNo:
            .byte       $00
CopyEndCharNo:
            .byte       $00
CopyCharLength:
            .byte       $00
CopyCharStatus:
            .byte       $00
CopyCharClear:
            .byte       $00
// ------------------------------------------------------------------------------------- | 
CopyCharEdit:
		lda		#$00							
		sta		CopyCharStatus						
		lda		#$01							 
		sta		CopyCharClear						
		lda		aCurrentCharNo						 
		sta		CopyStartCharNo						
!Loop:
		lda		CopyCharStatus						
		beq		!Cont1+						
		ldx		#<tReplaceTo						
		ldy		#>tReplaceTo							
		bne		!Cont2+						 
!Cont1:
		ldx		#<tEndCopychar							 
		ldy		#>tEndCopychar							 
!Cont2:
		jsr		PrintText						
		jsr		CopyCharColoring						 
		lda		aTmpKey							 
		ldx		#$06							
CheckNextKey:
		cmp		KeyOptionsCopyChar,x						 
		beq		!KeyPressed+						
		dex									
		bpl		CheckNextKey						
		bmi		!Loop-						
!KeyPressed:
		txa									
		asl									
		tax									
		lda		FunctionsCopyChar,x						
		sta		FPCopyChar+1						
		lda		FunctionsCopyChar+1,x					
		sta		FPCopyChar+2 					
FPCopyChar:
		jsr		$FF00					
		jmp		!Loop-						
// ------------------------------------------------------------------------------------- | 
KeyOptionsCopyChar:
		.byte		$53		//s
		.byte		$44		//d
		.byte 		$45		//e
		.byte 		$58		//x
		.byte		$03
		.byte		$C3
		.byte 		$0D		//Enter
// ------------------------------------------------------------------------------------- | 
FunctionsCopyChar:
		.word		CharLeft2			 		 		 
		.word		CharRight2						 
		.word		CharUp2					
		.word		CharDown2					
		.word		EndRestorecolors				
		.word		LABEL0D6D						
		.word		CopyCharPlace			
// ------------------------------------------------------------------------------------- | 
CopyCharPlace:
		lda		CopyEndCharNo						
		sec									
		sbc		CopyStartCharNo					
		sta		CopyCharLength						
		ldx		#$00							
		ldy		aCurrentCharNo							
!Loop:
		lda		aTmpCharcolors,x						
		sta		aCharcolors,y						
		cpx		CopyCharLength						
		beq		!Cont+					
		iny									
		inx								
		bne		!Loop-						
!Cont:
		lda		#$00							
		sta		$61							 
		lda		aCurrentCharNo							
		jsr		CalculateInCharset						
		lda		#$00							
		sta		$62							
		lda		#$48							
		sta		$63							
		ldx		#$00							
NextCopyChar:
		jsr		CopyCharFunction						
		cpx		CopyCharLength						 
		beq		!Cont1+						
		inx									
		bne		NextCopyChar						
!Cont1:
		jsr		SetCharsetColors					
		ldx		#<tKillOldchars							
		ldy		#>tKillOldchars				
		jsr		PrintText						
!WaitForKey:
		lda		aTmpKey						
		cmp		#$4E	//N for no						
		beq		!Cont2+						
		cmp		#$59	//Y for yes						
		bne		!WaitForKey-						
		lda		#$00							 
		sta		CopyCharClear						
		sta		$61							 
		lda		CopyStartCharNo						 
		jsr		CalculateInCharset						 
		ldx		#$00							 
NextCharToCLear:
		jsr		CopyCharFunction						 
		cpx		CopyCharLength						
		beq		!Cont2+						
		inx									
		bne		NextCharToCLear						
!Cont2:
		ldx		#<tReplaceMemory							 
		ldy		#>tReplaceMemory				
		jsr		PrintText						 
!ReleaseKeys:
		lda		aTmpKey							
		cmp		#$59		//Y for yes						
		beq		!ReleaseKeys-					
		cmp		#$4E		//N for No				
		beq		!ReleaseKeys-						
!WaitForKey:
		lda		aTmpKey							 
		cmp		#$4E							
		beq		!Endsub+						
		cmp		#$59							 
		bne		!WaitForKey-					 
		lda		aCurrentCharNo							
		sec									
		sbc		CopyStartCharNo						 
		sta		ValueToAdd+1						
		lda		#<aLevel						
		sta		$62							
		lda		#>aLevel							 
		sta		$63							 
		ldy		CopyEndCharNo						 
		iny									
		sty		CopyEndCharNo					
		ldy		#$00							
!Loop:
		lda		($62),y						
		cmp		CopyStartCharNo					
		bcc		!Cont3+						
		cmp		CopyEndCharNo					
		bcs		!Cont3+						
		clc								
ValueToAdd:
		adc		#$00							
		sta		($62),y						
!Cont3:
		inc		$62							
		bne		!Cont4+						
		inc		$63							
!Cont4:
		lda		$62							
		cmp		#<aLevel+LevelLength							
		bne		!Loop-						
		lda		$63							
		cmp		#>aLevel+LevelLength							
		bne		!Loop-						 
!Endsub:
		jsr		ShowLevel						
		jsr		DrawCharEditSquare						
		pla									
		pla									
		rts									
// ------------------------------------------------------------------------------------- | 
LABEL0D6D:
		
		lda		#$01							
		sta		CopyCharStatus						
		ldx		#$00							
		ldy		CopyStartCharNo						
!Loop:
		lda		aCharcolors,y						
		sta		aTmpCharcolors,x						
		cpy		CopyEndCharNo						
		beq		!Cont+						
		iny									
		inx									
		bne		!Loop-						
!Cont:
		jsr		CalculateCopyStartCharset						
		lda		#$00							
		sta		$60							
		lda		#$48							
		sta		$61							
		ldx		#$00							
!Loop2:
		jsr		CopyCharFunction						
		cpx		CopyEndCharNo						
		beq		!Endsub+					
		inx									
		bne		!Loop2-						
!Endsub:
		rts									
// ------------------------------------------------------------------------------------- | 
CalculateCopyStartCharset:
		lda		#<aCharset						
		sta		$63							
		lda		CopyStartCharNo						
		asl									
		rol		$63							
		asl									
		rol		$63							
		asl									
		rol		$63							
		sta		$62							
		lda		$63							
		adc		#>aCharset							
		sta		$63							
		rts									 
// ------------------------------------------------------------------------------------- | 
CalculateInCharset:
		asl									
		rol		$61							 
		asl									
		rol		$61						
		asl									
		rol		$61						
		sta		$60							
		lda		$61							
		adc		#>aCharset							
		sta		$61							 
		rts									 
// ------------------------------------------------------------------------------------- | 
CopyCharFunction:
		ldy		#$07						
!Loop:
		lda		CopyCharClear						 
		beq		!Cont1+					
		lda		($62),y						
!Cont1:
		sta		($60),y						
		dey									 
		bpl		!Loop-						
		lda		$62							
		clc									
		adc		#$08							
		sta		$62							
		bcc		!Cont2+						
		inc		$63							
!Cont2:
		lda		$60							
		clc									
		adc		#$08							 
		sta		$60							
		bcc		!Endsub+						
		inc		$61							
!Endsub:
		rts									
// ------------------------------------------------------------------------------------- | 
TmpBumpIndexL:
		.byte		$00							
TmpBumpIndexH:
		.byte		$00							
// ------------------------------------------------------------------------------------- | 
Bumpdata:
		jsr		ShowLevel						
ContBumpdata:
		ldx		#<tBumpdat							 
		ldy		#>tBumpdat						
		jsr		PrintText						
		ldx		#$00							
!Loop:
		lda		aCharcolors,x						
		sta		aTmpCharColorsForBump,x						
		inx									 
		bne		!Loop-						 
ShowBumpdat:
		inc		TmpBumpIndexL						
		bne		CheckBumpKey						 
		inc		TmpBumpIndexH						
		lda		TmpBumpIndexH						
		cmp		#$0A							
		bne		CheckBumpKey						 
		lda		#$00							
		sta		TmpBumpIndexH						
		ldx		#$00							
NextBumpdat:
		lda		aBumpdata,x						
		bne		ColBumpBlackWhite						
		lda		aTmpCharColorsForBump,x						
		jmp		ColBump						
// ------------------------------------------------------------------------------------- | 
ColBumpBlackWhite:
		lda		#$00							
ColBump:
		sta		aCharcolors,x						
		sta		$DAD0,x						
		inx									
		bne		NextBumpdat						
		lda		ColBumpBlackWhite+1						
		eor		#$01							
		sta		ColBumpBlackWhite+1						
		jsr		ShowLevel						
CheckBumpKey:
		lda		aTmpKey							
		ldx		#$07							
!NextKeyboardOption:
		cmp		KeyBoardOptions3,x					
		beq		!KeyPressed+					
		dex									
		bpl		!NextKeyboardOption-						
		bmi		ShowBumpdat						
!KeyPressed:
		txa								
		asl									
		tax									 
		lda		FunctionPointers3,x						
		sta		FunctionPointer3+1						
		lda		FunctionPointers3+1,x					
		sta		FunctionPointer3+2						
FunctionPointer3:
		jsr		$FF00						
		jsr		ShowLevel						
		jmp		ShowBumpdat						
// ------------------------------------------------------------------------------------- | 

KeyBoardOptions3:
		.byte		$9D //CursorLeft
		.byte 		$1D //CursorRight
		.byte		$91 //CursorUp
		.byte		$11 //CursorDown
		.byte		$03
		.byte		$0D //Enter Bumpdata on
		.byte		$8D //Shift Enter Bumpdata off
		.byte		$4B
// ------------------------------------------------------------------------------------- | 
FunctionPointers3:
		.word		CursorLeft								
		.word		CursorRight					 
		.word		CursorUp					 
		.word		CursorDown						 
		.word		EndBumpdata			 		
		.word		CharBumpdataOn			 			 
		.word		CharBumpdataOff				
		.word		KillBumpdata			
// ------------------------------------------------------------------------------------- | 
KillBumpdata:
		ldx		#<tKillBumpdata							
		ldy		#>tKillBumpdata							
		jsr		PrintText						
!Loop:
		lda		aTmpKey							 
		cmp		#$59	 //Y for yes						
		beq		!Proceed+						 
		cmp		#$4E	 //N for No						
		bne		!Loop-						
		beq		!End+						
!Proceed:
		ldx		#$00							
		txa									
!Loop:
		sta		aBumpdata,x						
		inx									
		bne		!Loop-						
!End:
		pla									 
		pla									 
		jmp		ContBumpdata						 
// ------------------------------------------------------------------------------------- | 
EndBumpdata:
		ldx		#$00							
!Loop:
		lda		aTmpCharColorsForBump,x						
		sta		aCharcolors,x						
		inx									 
		bne		!Loop-						 
		jmp		EndRestorecolors						
// ------------------------------------------------------------------------------------- | 
CharBumpdataOn:
		lda		#$80							
		bne		!Cont+						
CharBumpdataOff:
		lda		#$00							
!Cont:
		sta		PBumpdataValue+1						
		jsr		GotoCharOfLevelForeground					
		ldy		aCursorScreenPosX						
		lda		($42),y						
		tax									
PBumpdataValue:
		lda		#$00							
		sta		aBumpdata,x						 
		rts									
// ------------------------------------------------------------------------------------- | 
EndRestorecolors:
		pla									
		pla									
		jmp		SetCharsetColors					
// ------------------------------------------------------------------------------------- | 
CopyCharColoring:
		lda		CopyCharStatus						
		bne		!Cont+						
		lda		aCurrentCharNo							
		sta		CopyEndCharNo						
!Cont:
		lda		CopyCharColor+1						
		eor		#$01						
		sta		CopyCharColor+1						
CopyCharColor:
		lda		#$00							 
		ldy		CopyStartCharNo						
Color:
!Loop:
		sta		$DAD0,y						
		cpy		CopyEndCharNo						
		beq		!Endsub+						
		iny									
		bne		!Loop-						
!Endsub:
		rts									
// ------------------------------------------------------------------------------------- | 
CharLeft2:
		lda		CopyCharStatus						
		bne		!Cont+						
		lda		aCurrentCharNo							 
		cmp		CopyStartCharNo						
		beq		!Rts+						
!Cont:
		dec		aCurrentCharNo						
		jmp		SetCharsetColors					
// ------------------------------------------------------------------------------------- | 
CharRight2:
		lda		CopyCharStatus						
		bne		!Cont+						
		lda		aCurrentCharNo							 
		cmp		#$FC							
		beq		!Rts+						
!Cont:
		inc		aCurrentCharNo						
		rts									
// ------------------------------------------------------------------------------------- | 
CharUp2:
		lda		aCurrentCharNo							
		sec									
		sbc		#$28							
		cmp		CopyStartCharNo						
		bcc		!ContCopy+						
		cmp		#$D8							
		bcs		EndCharUp2						
		sta		aCurrentCharNo							
EndCharUp2:
		jmp		SetCharsetColors						
// ------------------------------------------------------------------------------------- | 
!ContCopy:
		ldy		CopyCharStatus						
		beq		EndCharUp2						 
		sta		aCurrentCharNo						
		jmp		SetCharsetColors					
// ------------------------------------------------------------------------------------- | 
CharDown2:
		lda		aCurrentCharNo						
		clc									
		adc		#$28							
		bcs		!Rts+						
		sta		aCurrentCharNo							
!Rts:
		rts									
// ------------------------------------------------------------------------------------- | 
SetCharsetColors:
		ldy		#$00						
!Loop:
		lda		aCharcolors,y						
		sta		$DAD0,y						 
		iny									
		bne		!Loop-						
		rts									
// ------------------------------------------------------------------------------------- | 
SwitchForBackMode:
		lda		aForBackMode							
		eor		#$01							
		sta		aForBackMode							
		rts									
// ------------------------------------------------------------------------------------- | 
ScrollLeft40:
		lda		aScreenPosXL							
		cmp		#$68							
		bne		!Cont+						
		lda		aScreenPosXH						
		cmp		#$01						
		beq		!Endsub+						
!Cont:
		inc		aScreenPosXL						
		bne		!Endsub+						
		inc		aScreenPosXH				
		rts									
// ------------------------------------------------------------------------------------- | 
ScrollRight40:
		lda		aScreenPosXL							 
		bne		!Cont+						
		lda		aScreenPosXH						
		beq		!Endsub+						
!Cont:
		dec		aScreenPosXL							
		lda		aScreenPosXL				
		cmp		#$FF							 
		bne		!Endsub+						 
		dec		aScreenPosXH							
		jmp		!Endsub+					
// ------------------------------------------------------------------------------------- | 
ScrollLeft:
		lda		aScreenPosXL							
		clc									
		adc		#$28							
		sta		aScreenPosXL				
		lda		aScreenPosXH							
		adc		#$00							
		sta		aScreenPosXH							 
		cmp		#$01							
		bne		!Endsub+						 
		lda		aScreenPosXL							
		cmp		#$68							
		bcc		!Endsub+						
		lda		#$68							
		sta		aScreenPosXL							
		rts								
// ------------------------------------------------------------------------------------- | 
ScrollRight:
		lda		aScreenPosXL							
		sec									
		sbc		#$28							
		sta		aScreenPosXL							
		lda		aScreenPosXH							
		sbc		#$00							
		sta		aScreenPosXH						
		cmp		#$FF							
		bne		!Endsub+						
		lda		#$00						
		sta		aScreenPosXL							 
		sta		aScreenPosXH					
!Endsub:
		rts									
// ------------------------------------------------------------------------------------- | 
HideForeGround:
		lda		aHideForGroundMode							
		eor		#$01						
		sta		aHideForGroundMode							
		rts								
// ------------------------------------------------------------------------------------- | 
RepeatKeys:
		ldx		#<tRepeatKeys							
		ldy		#>tRepeatKeys					
		jsr		PrintText						
!Loop:
		lda		aTmpKey							
		cmp		#$59							
		beq		SetRepeatKeys						
		cmp		#$4E							
		bne		!Loop-						
		lda		#$00							
		.byte		$2C						 
SetRepeatKeys:
		lda		#$80							
		sta		$028A							
		rts									
// ------------------------------------------------------------------------------------- | 
GotoCharOfLevel:
		lda		aForBackMode						
		beq		!Cont+						
		jsr		GotoCharOfLevelBackground						
		jmp		!SetCurrentCharNo+						
// ------------------------------------------------------------------------------------- | 
!Cont:
		jsr		GotoCharOfLevelForeground						
!SetCurrentCharNo:
		ldy		aCursorScreenPosX						
		lda		($42),y						 
		sta		aCurrentCharNo							 
		rts									
// ------------------------------------------------------------------------------------- | 
PlaceCharInlevel:
		lda		aForBackMode						
		beq		SetCharLevelInForeground						
		jsr		GotoCharOfLevelBackground						 
		jmp		SetCharLevel						
// ------------------------------------------------------------------------------------- | 
GotoCharOfLevelBackground:
		lda		aScreenPosXH							
		lsr									
		sta		PLevelBackgroundH+1						 
		lda		aScreenPosXL							 
		ror									
		sta		PLevelBackgroundL+1						
		lda		aCursorScreenPosY						
		cmp		#$06							 
		bcc		!PlaPlaRts+					
		cmp		#$10							
		bcs		!PlaPlaRts+						
		sec									
		sbc		#$06						
		asl									
		tax									
		lda		BackgroundStarts,x						 
		clc									 
PLevelBackgroundL:
		adc		#$00							
		sta		$42							
		lda		BackgroundStarts+1,x						 
PLevelBackgroundH:
		adc		#$00							
		sta		$43							
		rts									
// ------------------------------------------------------------------------------------- | 
!PlaPlaRts:
		pla									
		pla									
		rts									
// ------------------------------------------------------------------------------------- | 
SetCharLevelInForeground:
		jsr		GotoCharOfLevelForeground						 
SetCharLevel:
		ldy		aCursorScreenPosX							
		lda		aCurrentCharNo						
		sta		($42),y						
		rts									
// ------------------------------------------------------------------------------------- | 
GotoCharOfLevelForeground:
		lda		aScreenPosXL						 
		clc									
		adc		#<aLevel							
		sta		PLevelForegroundL+1					
		lda		aScreenPosXH							
		adc		#>aLevel							
		sta		PLevelForegroundH+1						 
		lda		aCursorScreenPosY						
		asl									 
		tay									
		lda		ForegroundStarts,y						
		clc									
PLevelForegroundL:
		adc		#$00							
		sta		$42							
		lda		ForegroundStarts+1,y						
PLevelForegroundH:
		adc		#$00							
		sta		$43							
		rts									
// ------------------------------------------------------------------------------------- | 
CursorLeft:
		lda		aCursorScreenPosX							
		bne		NotOnLeftborderYet						
		lda		aScreenPosXL							
		bne		!Cont+						 
		lda		aScreenPosXH						 
		beq		!Endsub+						
!Cont:
		dec		aScreenPosXL						
		lda		aScreenPosXL							
		cmp		#$FF							 
		bne		!Endsub+						
		dec		aScreenPosXH							
!Endsub:
		rts									
// ------------------------------------------------------------------------------------- | 
NotOnLeftborderYet:
		dec		aCursorScreenPosX							
		rts									
// ------------------------------------------------------------------------------------- | 
CursorRight:
		lda		aCursorScreenPosX							
		cmp		#$27							
		bne		IncCursorScreenPosX						
		lda		aScreenPosXL						
		cmp		#$68							
		bne		!Cont+						
		lda		aScreenPosXH							
		cmp		#$01							
		beq		!Endsub+						 
!Cont:
		inc		aScreenPosXL							 
		bne		!Endsub+						 
		inc		aScreenPosXH							
!Endsub:
		rts									
// ------------------------------------------------------------------------------------- | 
IncCursorScreenPosX:
		inc		aCursorScreenPosX							 
		rts									
// ------------------------------------------------------------------------------------- | 
CursorUp:
		lda		aCursorScreenPosY							 
		beq		!Endsub+						
		dec		aCursorScreenPosY							
		dec		$4F							
!Endsub:
		rts									
// ------------------------------------------------------------------------------------- | 
CursorDown:
		lda		aCursorScreenPosY						 
		cmp		#$11							
		beq		!Endsub+						 
		inc		aCursorScreenPosY							
		inc		$4F							 
!Endsub:
		rts									
// ------------------------------------------------------------------------------------- | 
PBlockCopyL:
		.byte		$00							
PBlockCopyH:
		.byte		$00							
TmpCopyY:
		.byte		$00, $00, $00					
TmpEndOfBlockCopyL:
		.byte		$00							
TmpEndOfBlockCopyH:
		.byte		$00							
CopyBlockStart:
		.byte		$00							
TmpStartOfBlockCopyL:
		.byte		$00							
TmpStartOfBlockCopyH:
		.byte		$00		
					
// ------------------------------------------------------------------------------------- | 
CopyInForeGround:
		lda		#$01							
		sta		PasteState+1						
		lda		aScreenPosXL						
		clc									
		adc		aCursorScreenPosX						
		sta		PBlockCopyLValue+1						 
		lda		aScreenPosXH						
		adc		#$00							
		sta		PBlockCopyHValue+1						
PBlockCopyLValue:
		lda		#$00							
		sta		PBlockCopyL						
PBlockCopyHValue:
		lda		#$00							 
		sta		PBlockCopyH

		lda		$4F							
		sta		TmpCopyY						
		jsr		CalculateStartOfBlock					 
		lda		$4B							
		sta		TmpStartOfBlockCopyL						
		lda		$4C							
		sta		TmpStartOfBlockCopyH						
		rts									
// ------------------------------------------------------------------------------------- | 
BlockCopyEndInForeGround:
		lda		PasteState+1						
		cmp		#$01							 
		bne		!BlockError+						
		lda		#$80							
		sta		PasteState+1						
		lda		aScreenPosXL							
		clc									 
		adc		aCursorScreenPosX							
		sta		(!PReadL+)+1						
		lda		aScreenPosXH							
		adc		#$00							
		sta		(!PReadH+)+1						
!PReadL:
		lda		#$00							
		sec									
		sbc		PBlockCopyL						 
		sta		TmpEndOfBlockCopyL						
!PReadH:
		lda		#$00							 
		sbc		PBlockCopyH						
		sta		TmpEndOfBlockCopyH						
		bcc		!BlockError+						
		lda		$4F							 
		sec									
		sbc		TmpCopyY						
		sta		CopyBlockStart						
		bcs		!ContCopy+						
!BlockError:
		jmp		BlockError						
// ------------------------------------------------------------------------------------- | 
!ContCopy:
		lda		#<aLevel							
		sta		$4B							
		lda		#>aLevel							
		sta		$4C							
		ldy		TmpCopyY						
		beq		!Cont+						
!Loop:
		lda		$4B							
		clc									
		adc		#$90							
		sta		$4B							
		lda		$4C							
		adc		#$01							 
		sta		$4C							
		dey									
		bne		!Loop-						
!Cont:
		lda		$4B							
		clc									
		adc		PBlockCopyL						
		sta		$4B							
		lda		$4C							
		adc		PBlockCopyH						
		sta		$4C							
		lda		#<aTmpBlockToPaste							
		sta		PWriteBlockToPaste+1						
		lda		#>aTmpBlockToPaste						
		sta		PWriteBlockToPaste+2						
		ldx		#$00							
!Loop1:
		ldy		#$00							 
!Loop2:
		lda		($4B),y						
PWriteBlockToPaste:
		sta		$ff00							 
		inc		PWriteBlockToPaste+1						
		bne		!Cont2+						 
		inc		PWriteBlockToPaste+2						
!Cont2:
		cpy		TmpEndOfBlockCopyL						 
		beq		!Cont1+						 
		iny									 
		bne		!Loop2-						
!Cont1:
		cpx		CopyBlockStart						 
		beq		!Endsub+						
		lda		$4B							
		clc									
		adc		#$90							
		sta		$4B							
		lda		$4C							
		adc		#$01							 
		sta		$4C							 
		inx									 
		bne		!Loop1-						
!Endsub:
		rts									
// ------------------------------------------------------------------------------------- | 
PasteState:
PasteInForeGround:
		lda		#$00							 
		bpl		!BlockError+						
		jsr		CalculateStartOfBlock						
		lda		#<aTmpBlockToPaste							
		sta		PBlockCopyLevel+1						
		lda		#>aTmpBlockToPaste							 
		sta		PBlockCopyLevel+2						
		ldx		#$00						
!Loop:
		ldy		#$00
!Loop2:			
PBlockCopyLevel:
		lda		$ff00							
		sta		($4B),y						
		inc		PBlockCopyLevel+1						
		bne		!Cont+						
		inc		PBlockCopyLevel+2						
!Cont:
		cpy		TmpEndOfBlockCopyL						 
		beq		!Cont1+						
		iny									 
		bne		!Loop2-						 
!Cont1:
		cpx		CopyBlockStart						
		beq		!Endsub+						
		inx									 
		lda		$4B							
		clc									
		adc		#$90							 
		sta		$4B							
		lda		$4C							
		adc		#$01							
		sta		$4C							
		jmp		!Loop-	
!BlockError:
		jmp 	BlockError					
// ------------------------------------------------------------------------------------- | 
!Endsub:
		rts									 
// ------------------------------------------------------------------------------------- | 
CalculateStartOfBlock:
		lda		#<aLevel						
		sta		$47							
		lda		#>aLevel							
		sta		$48							
		ldy		#$00							 
!Loop:
		cpy		$4F		//Ypos(line) of copy					
		beq		!Cont+						 
		lda		$47							
		clc									
		adc		#$90							
		sta		$47							
		lda		$48							
		adc		#$01							
		sta		$48							
		iny									
		bne		!Loop-						
!Cont:
		lda		aScreenPosXL						 
		clc								
		adc		aCursorScreenPosX							 
		sta		(!AddL+)+1						 
		lda		aScreenPosXH							
		adc		#$00						
		sta		(!AddH+)+1							
		lda		$47							
		clc									
!AddL:
		adc		#$00							
		sta		$4B							
		lda		$48							
!AddH:
		adc		#$00							
		sta		$4C							
		rts								
// ------------------------------------------------------------------------------------- | 
ScreenBackPosXL:
            .byte       $00
ScreenBackPosXH:
            .byte       $00
// ------------------------------------------------------------------------------------- | 
ShowLevel:
		lda		#<aLevel							 
		clc								
		adc		aScreenPosXL							
		sta		PLevel+1						
		lda		#>aLevel							 
		adc		aScreenPosXH							
		sta		PLevel+2						
		lda		aScreenPosXH							
		lsr									
		sta		ScreenBackPosXH						
		lda		aScreenPosXL						
		ror									
		sta		ScreenBackPosXL						
		lda		#<aScreen							 
		sta		PScreen+1						
		lda		#>aScreen							
		sta		PScreen+2						
		lda		#<aColorMemory							
		sta		PColorMemory+1						
		lda		#>aColorMemory							 
		sta		PColorMemory+2						
		lda		#$00							 
		sta		aLineNumber							
DrawLine:
		ldy		#$27
DrawChar:							 
PLevel:
		lda		$ff00,y					
		ldx		aHideForGroundMode						
		beq		DrawBackgroundChar						 
		cmp		#$00							
		bne		!StoreOnscreen+								
DrawBackgroundChar:
		lda		#$00							 
		ldx		aLineNumber							
		cpx		#$06							
		bcc		!StoreOnscreen+						 
		cpx		#$10							
		bcs		!StoreOnscreen+								
		txa									
		sbc		#$05							 
		asl									
		tax									
		lda		BackgroundStarts,x						
		clc									
		adc		ScreenBackPosXL						 
		sta		PLevelBack+1						
		lda		BackgroundStarts+1,x						
		adc		ScreenBackPosXH						
		sta		PLevelBack+2						 
PLevelBack:
		lda		$ff00,y
!StoreOnscreen:					
PScreen:
		sta		$ff00,y						 
		tax									
		lda		aCharcolors,x						
PColorMemory:
		sta		$ff00,y						
		dey									
		bpl		DrawChar

		lda		PLevel+1						
		clc									
		adc		#$90							
		sta		PLevel+1						
		lda		PLevel+2						
		adc		#$01							 
		sta		PLevel+2						
		lda		PScreen+1						
		clc									 
		adc		#$28							 
		sta		PScreen+1						
		bcc		!Cont+						 
		inc		PScreen+2						
!Cont:
		lda		PColorMemory+1						
		clc									
		adc		#$28							
		sta		PColorMemory+1						
		bcc		!Cont1+						
		inc		PColorMemory+2						
!Cont1:
		inc		aLineNumber							 
		lda		aLineNumber							
		cmp		#$12							
		bne		DrawLine						 
		rts									
// ------------------------------------------------------------------------------------- | 
TmpCalculatePositionBack:
		.word		$0000
TmpCopyBackY:
		.byte		$00
        .byte		$00
        .byte		$00
PositionBack:
        .word		$0000
TmpWorkCopyBackY:
        .byte		$00
PositionEndBack:
        .word		$0000
aScreenPosBackX:
		.word		$0000
// ------------------------------------------------------------------------------------- | 
CalculateScreenBack:
		lda		aScreenPosXH							
		lsr									
		sta		aScreenPosBackX+1						
		lda		aScreenPosXL						
		ror									
		sta		aScreenPosBackX						 
		lda		aScreenPosBackX						
		clc									 
		adc		aCursorScreenPosX						
		sta		aScreenPosBackX						
		lda		aScreenPosBackX+1						
		adc		#$00						
		sta		aScreenPosBackX+1						
		rts									
// ------------------------------------------------------------------------------------- | 
CopyInBackground:
		lda		aCursorScreenPosY							
		cmp		#$06							
		bcc		!BlockError+						
		cmp		#$10							 
		bcs		!BlockError+						
		lda		#$01							
		sta		AllSetForCopyBack+1						 
		jsr		CalculateScreenBack						
		lda		aScreenPosBackX					
		sta		TmpCalculatePositionBack						
		lda		aScreenPosBackX+1						
		sta		TmpCalculatePositionBack+1					
		lda		aCursorScreenPosY							
		sec									
		sbc		#$06							 
		sta		TmpCopyBackY						
		jsr		CalculatePositionBack						
		lda		$49							
		sta		PositionEndBack						
		lda		$4A							
		sta		PositionEndBack+1						
		rts									
// ------------------------------------------------------------------------------------- | 
BlockCopyEndInBackGround:
		lda		aCursorScreenPosY							
		cmp		#$06							
		bcc		!BlockError+						
		cmp		#$10							
		bcs		!BlockError+						
		lda		AllSetForCopyBack+1						
		cmp		#$01							
		bne		!BlockError+						
		lda		#$81							
		sta		AllSetForCopyBack+1						 
		jsr		CalculateScreenBack					
		lda		aScreenPosBackX						
		sec									
		sbc		TmpCalculatePositionBack						
		sta		PositionBack						
		lda		aScreenPosBackX+1						
		sbc		TmpCalculatePositionBack+1						
		sta		PositionBack+1						
		bcc		!BlockError+						
		lda		aCursorScreenPosY						
		sec									
		sbc		#$06							
		sbc		TmpCopyBackY						
		sta		TmpWorkCopyBackY						
		bcs		!Cont+					
!BlockError:
		jmp		BlockError						
// ------------------------------------------------------------------------------------- | 
!Cont:
		lda		#<aLevelBackground							
		sta		$49							
		lda		#>aLevelBackground							
		sta		$4A							
		ldy		TmpCopyBackY						
		beq		!Cont+						 
!Loop:
		lda		$49							
		clc									
		adc		#$DC							
		sta		$49							
		lda		$4A							 
		adc		#$00						
		sta		$4A							
		dey									 
		bne		!Loop-						
!Cont:
		lda		$49							
		clc									 
		adc		TmpCalculatePositionBack						 
		sta		$49							
		lda		$4A							
		adc		TmpCalculatePositionBack+1						
		sta		$4A							
		lda		#<aTmpBlockToPaste							
		sta		BlockToPaste+1						
		lda		#>aTmpBlockToPaste							 
		sta		BlockToPaste+2				      
		ldx		#$00							
!Loop1:
		ldy		#$00							
LABEL135C:
		lda		($49),y						
BlockToPaste:
		sta		$ff00							 
		inc		BlockToPaste+1						
		bne		!Cont1+						
		inc		BlockToPaste+2						
!Cont1:
		cpy		PositionBack						
		beq		!Cont2+						
		iny									
		bne		LABEL135C						
!Cont2:
		cpx		TmpWorkCopyBackY						
		beq		!Endsub+						
		lda		$49							
		clc									
		adc		#$DC						
		sta		$49							
		lda		$4A							
		adc		#$00						
		sta		$4A						
		inx									
		bne		!Loop-						 
!Endsub:
		rts									 
// ------------------------------------------------------------------------------------- | 
PasteInBackGround:
		lda		aCursorScreenPosY							
		cmp		#$06							
		bcc		!BlockError+						 
		cmp		#$10							
		bcs		!BlockError+						
AllSetForCopyBack:
		lda		#$00							 
		bpl		!BlockError+						
		jsr		CalculatePositionBack						
		lda		#<aTmpBlockToPaste							
		sta		PValueToPasteBack+1						
		lda		#>aTmpBlockToPaste							
		sta		PValueToPasteBack+2						
		ldx		#$00							
!Loop:
		ldy		#$00
!Loop1:				
PValueToPasteBack:
		lda		$ff00							
		sta		($49),y						
		inc		PValueToPasteBack+1						
		bne		!Cont+						
		inc		PValueToPasteBack+2						
!Cont:
		cpy		PositionBack						
		beq		!Cont1+						
		iny									
		bne		!Loop1-						
!Cont1:
		cpx		TmpWorkCopyBackY						
		beq		!Endsub+						
		inx									
		lda		$49							
		clc									
		adc		#$DC							
		sta		$49							
		lda		$4A							
		adc		#$00							
		sta		$4A							 
		jmp		!Loop-						
!Endsub:
		rts	
!BlockError:
		jmp		BlockError								
// ------------------------------------------------------------------------------------- | 
CalculatePositionBack:
		lda		aCursorScreenPosY							
		sec								
		sbc		#$06							
		asl									
		tay									 
		lda		BackgroundStarts,y					
		sta		$49							
		lda		BackgroundStarts+1,y						
		sta		$4A							
		jsr		CalculateScreenBack						
		lda		$49						
		clc									
		adc		aScreenPosBackX					
		sta		$49							
		lda		$4A							
		adc		aScreenPosBackX+1						
		sta		$4A						
		rts									
// ------------------------------------------------------------------------------------- | 
Irq1:
		
		sta		aTmpA							
		stx		aTmpX						
		sty		aTmpY					
		lda		#$01						
		sta		$D019						 
		lda		#$1B							
		sta		$D011							
		lda		#$00
		sta		$D010
		lda		#$FF
		sta		$D015
		lda		#$1D   //Sprite on location $c740
		sta		$C3F8							
		lda		#$1C   //Sprite on location $c780							
		sta		$C3F9							 
		lda		aTmpMultiCol1						
		sta		$D022							
		lda		aUpperMultiCol2						
		sta		aTmpMultiCol2							
		lda		aLevelCharEditMode							
		bne		!Cont+					
		lda		#$00						 
		sta		$D01D							
		lda		aCursorScreenPosX					
		asl									
		asl									
		adc		#$0C						
		asl									
		sta		$D000							
		bcc		!Cont3+						
		inc		$D010							
!Cont3:
		lda		aCursorScreenPosY						
		asl								
		asl								
		asl									
		adc		#$32							
		sta		$D001															
		jmp		!Cont1+						 
// ------------------------------------------------------------------------------------- | 
!Cont:
		lda		#$01						
		sta		$D01D //Double with sprite			
		lda		aCharEditPixelX						
		asl								
		asl									
		asl								
		adc		#$10							
		asl									
		sta		$D000							
		bcc		!Cont2+					
		inc		$D010						
!Cont2:
		lda		aCharEditPixelY						
		asl									
		asl								
		asl									
		adc		#$3A							 
		sta		$D001																	
!Cont1:
		ldy		#$00							
		lda		aCurrentCharNo						
!Loop:
		tax									
		sec									
		sbc		#$28							
		bcc		!Cont4+						
		iny									
		bne		!Loop-						
!Cont4:
		txa									
		asl									
		asl									
		adc		#$0C							
		asl								
		sta		$D002															
		bcc		!Cont5+						
		lda		$D010																	
		ora		#$02							
		sta		$D010						
!Cont5:
		tya									
		asl								 
		asl									 
		asl								
		adc		#$B5							 
		sta		$D003						
		jsr		SpritesFlashing				
		lda		#$31							
!WaitForRaster:
		cmp		$D012											
		bcs		!WaitForRaster-						
		ldy		#$08							
!Wait:
		dey								
		bpl		!Wait-				
		lda		aTmpBackCol						
		sta		$D021							
		lda		aLowerBackCol							
		sta		BackColorIrq2+1					
		lda		aLowerMultiCol1							
		sta		MultiCol1Irq2+1					 
		lda		aLowerMultiCol2						
		sta		MultiCol2Irq2+1						
		lda		aUpDownMode							
		beq		UseUpperCol						 
		lda		aLowerBackCol							 
		ldx		aLowerMultiCol1							
		ldy		aLowerMultiCol2						
		jmp		ContCol						
// ------------------------------------------------------------------------------------- | 
UseUpperCol:
		lda		aUpperBackCol							
		ldx		aUpperMultiCol1					
		ldy		aUpperMultiCol2							
ContCol:
		sta		aTmpBackCol						
		stx		aTmpMultiCol1							
		sty		aTmpMultiCol2						
		jsr		SetCharNoDisplay					
		lda		#$37							
		sta		$01						
		jsr		$EA87	//Query keyboard; put current matrix code into memory address $00CB, current status of shift keys into memory address $028D and PETSCII code into keyboard buffer; handle Commodore-Shift; repeat keys.					
		jsr		$FFE4	//GETIN. Read byte from default input. (If not keyboard, must call OPEN and CHKIN beforehands.)						
		sta		aTmpKey						
		lda		#$35						
		sta		$01							 
		lda		#$B2							 
		ldx		#<Irq2						
		ldy		#>Irq2						 
		sta		$D012					
		stx		$FFFE						
		sty		$FFFF							
		lda		aTmpA						
		ldx		aTmpX							
		ldy		aTmpY							
		rti									
// ------------------------------------------------------------------------------------- | 
Irq2:
		sta		aTmpA					
		stx		aTmpX			
		sty		aTmpY							
		ldy		#$04							
!Wait:
		dey								
		bpl		!Wait-					
		nop								
		nop								
BackColorIrq2:
		lda		#$07						
MultiCol1Irq2:
		ldx		#$08				
MultiCol2Irq2:
		ldy		#$09
		stx		$D022							
		sty		$D023					
		sta		$D021						
		lda		#$C1						
		ldx		#<Irq3					
		ldy		#>Irq3					 
		jmp		FinishInterupt				
// ------------------------------------------------------------------------------------- | 
Irq3:
		sta		aTmpA					
		stx		aTmpX					
		sty		aTmpY			
		ldy		#$0E						
Loop2:
		dey								
		bpl		Loop2				
		lda		aTmpBackCol			
		ldx		aTmpMultiCol1						
		ldy		aTmpMultiCol2					
		sta		$D021				
		stx		$D022	
		sty		$D023						
		lda		#$FA					
		ldx		#<Irq4				
		ldy		#>Irq4					
		jmp		FinishInterupt
// ------------------------------------------------------------------------------------- | 
Irq4:
		sta		aTmpA
		stx		aTmpX	 
		sty		aTmpY	
		lda		#$13
		sta		$D011	
		ldy		#$06						
!Loop:
		dey							
		bne		!Loop-	
		sty		$D021					
		jsr		DrawLetterSprites					
		lda		#$00							
		ldx		#<Irq5				
		ldy		#>Irq5				
		jmp		FinishInterupt					
// ------------------------------------------------------------------------------------- | 
Irq5:
		sta		aTmpA						
		stx		aTmpX							
		sty		aTmpY						
		lda		#$00	
		sta		$D015											
		lda		#$2D						
		ldx		#<Irq1						
		ldy		#>Irq1				 
FinishInterupt:
		sta		$D012															
		stx		$FFFE						
		sty		$FFFF						
		lda		#$01							
		sta		$D019						
		lda		aTmpA				
		ldx		aTmpX						
		ldy		aTmpY						
Nmi:
		rti



// ------------------------------------------------------------------------------------- | 
tCharEdit:
		.text		"CHAREDIT.            CHARNO.$"
tCharEditCharNo:
	    .text		"00 "
// ------------------------------------------------------------------------------------- |
tUpOrDownMode1: 
		.text 		"UPSTAIRS  "
tForgroundEdit:
		.text 		"FORGROUND EDIT.       CHARNO.$"
tForgroundEditCharNo:
        .text		"00 "
tUpOrDownMode2:
		.text 		"UPSTAIRS "
tBackgroundEdit:
		.text 		"BACKGROUND EDIT.     CHARNO.$"
tBackgrounndEditCharNo:
		.text		"00 "
tUpOrDownMode3:
		.text		"UPSTAIRS  "
tUpStairsUnder:
tEditorText:
		.text		"UPSTAIRSUNDER   "
tBlockError:
		.text		"<BLOCK ERROR.>       "
		.text		"PRESS SPACE TO CONT."
tRepeatKeys:
		.text		"REPEAT KEYS ?        "
		.text		"(Y)ES OR (N)O.       "
tEndCopychar:
		.text		"END COPYCHAR ?       "
		.text		"CANCEL WITH <RUNST.> "
tReplaceTo:
		.text		"REPLACE TO ?         "
		.text		"CANCEL WITH <RUNST.> "
tKillOldchars:
		.text		"KILL OLD CHARS ?     "
		.text		"(Y)ES OR (N)O.       "
tReplaceMemory:
		.text		"REPLACE MEMORY ?     "
		.text		"(Y)ES OR (N)O.       "
tBumpdat:
		.text		"BUMPDAT. $80         "
		.text		"CANCEL WITH <RUNST.> "
tKillBumpdata:
		.text		"KILL BUMPDATE ?      "
		.text		"(Y)ES OR (N)O.       "
tPleaseWait:
		.text		"PLEASE WAIT.         "
		.text		"FILLING UNUSED CHARS "
tEndBackgroundChars:
		.text		"END BACKGROUND CHARS "
		.text		"AND PRESS RETURN     "
tBackgroundError:
		.text		"<BACKGROUND ERROR.>  "
		.text		"PRESS SPACE TO CONT. "
		.text		"SHOWING BACKGROUND.  "
		.text		"PRESS SPACE TO CONT. "
// ------------------------------------------------------------------------------------- | 
BlockError:
		ldx		#<tBlockError							
		ldy		#>tBlockError					
		jsr		PrintText	 
WaitForSpace1:
		lda		$DC01						
		cmp		#$EF							
		bne		WaitForSpace1					 
		rts									
// ------------------------------------------------------------------------------------- | 
DrawLetterSprites:
		lda		#$00							
		sta		$D010							 
		sta		$D017							
		lda		#$7F							
		sta		$D015							
		sta		$D01D							
		ldy		#$0C							 
		ldx		#$06							
NextLetterSprite:
		//3e00
		lda		LetterSpritePointers,x					
		sta		aScreen + $03F8,x					
		lda		LetterSpriteXPositions,x						
		asl									
		sta		$D000,y						
		rol		$D010																		
		lda		YposLetterSprites						
		sta		$D001,y						
		lda		#$05							 
		sta		$D027,x						
		dey									
		dey									
		dex									
		bpl		NextLetterSprite					
		rts									
// ------------------------------------------------------------------------------------- | 
CharEditPixelXMin:
		dec		aCharEditPixelX						
		jmp		CharEditPixelX						 
// ------------------------------------------------------------------------------------- | 
CharEditPixelXPlus:
		inc		aCharEditPixelX							
CharEditPixelX:
		lda		aCharEditPixelX							
		and		#$03							
		sta		aCharEditPixelX						
		rts									
// ------------------------------------------------------------------------------------- | 
CharEditPixelYMin:
		dec		aCharEditPixelY							
		jmp		CharEditPixelY						
// ------------------------------------------------------------------------------------- | 
CharEditPixelYPlus:
		inc		aCharEditPixelY							
CharEditPixelY:
		lda		aCharEditPixelY						
		and		#$07							
		sta		aCharEditPixelY							
		rts									
// ------------------------------------------------------------------------------------- | 
ClearCharInLevel:
		lda		#$00							
		sta		aCurrentCharNo							
		jmp		PlaceCharInlevel						
// ------------------------------------------------------------------------------------- | 
ClearEditorScreen:
		ldy		#$00							
		tya									
!Loop:
		sta		aScreen,y						
		sta		aScreen+$0100,y						 
		sta		aScreen+$0200,y						
		sta		aScreen+$02E8,y						
		iny									
		bne		!Loop-						 
		rts									
// ------------------------------------------------------------------------------------- | 
SetColorCurChar:
		ldx		aCurrentCharNo						
		lda		aCharcolors,x						
		sta		aCharcolors+$00ff						
		ldx		#$00							
!FillCont:
		lda		aCharcolors,x						
		sta		$DAD0,x						
		inx									
		bne		!FillCont-						
		rts									
// ------------------------------------------------------------------------------------- | 
CharColNext:
		ldx		aCurrentCharNo							
		inc		aCharcolors,x						
		jmp		SetCharcolors						
// ------------------------------------------------------------------------------------- | 
CharColPrev:
		ldx		aCurrentCharNo						
		dec		aCharcolors,x						
SetCharcolors:
		lda		aCharcolors,x						
		and		#$07							
		ora		#$08							
		sta		aCharcolors,x						
		rts									
// ------------------------------------------------------------------------------------- | 
MultiCollUp1Next:
		inc		aUpperMultiCol1							
		rts									
// ------------------------------------------------------------------------------------- | 
MultiCollUp2Next:
		inc		aUpperMultiCol2							
		rts									 
// ------------------------------------------------------------------------------------- | 
BackCollUpNext:
		inc		aUpperBackCol							
		rts								
// ------------------------------------------------------------------------------------- | 
MultiCollLower1Next:
		inc		aLowerMultiCol1							
		rts									
// ------------------------------------------------------------------------------------- | 
MultiCollLower2Next:
		inc		aLowerMultiCol2				
		rts									
// ------------------------------------------------------------------------------------- | 
BackCollLowerNext:
		inc		aLowerBackCol							
		rts									
// ------------------------------------------------------------------------------------- | 
DrawCharEditSquare:
		ldx		#$09							
		lda		#>aScreen							
		sta		PScreenCharEditSq+2					
		lda		#<aScreen							
		sta		PScreenCharEditSq+1						 
!Loop:
		lda		#$FF							
		ldy		#$09
PScreenCharEditSq:					
NextEl:
		sta		$C190,y						
		dey									
		bpl		NextEl						
		lda		PScreenCharEditSq+1						
		clc									
		adc		#$28							
		sta		PScreenCharEditSq+1						
		bcc		!Cont+						 
		inc		PScreenCharEditSq+2						
!Cont:
		dex									
		bpl		!Loop-						
		rts									
// ------------------------------------------------------------------------------------- | 
DrawBigCharEdit:
//Draw Character colors
		ldx		aCurrentCharNo							
		lda		aCharcolors,x						
		ldy		#$09							 
!Loop:
		sta		$D800,y						
		sta		$D828,y					
		sta		$D850,y						 
		sta		$D878,y						
		sta		$D8A0,y						
		sta		$D8C8,y						
		sta		$D8F0,y						
		sta		$D918,y						
		sta		$D940,y						 
		sta		$D968,y						 
		dey									 
		bpl		!Loop-	
//End draw Character colors
		txa									
		jsr		CalculatePosInCharset
		lda		#$41							
		sta		$20							
		lda		#$C1							
		sta		$21							
		ldy		#$07							
Loop3:
		ldx		#$03							
CharsetNextPixel:
		lda		(aPointerCharset),y						 
		and		CharTestPixelsX,x						
		pha									
		and		#$AA							 
		beq		c2						
		lda		#$02							 
c2:
		sta		$31							
		pla									
		and		#$55							
		beq		c3						
		lda		$31							
		ora		#$01							 
		sta		$31							
c3:
		sty		$30							
		txa									
		asl									
		tay									
		lda		$31							
		bne		c4						 
		lda		#$FC							
		bne		c5						
c4:
		adc		#$FC							
c5:
		sta		($20),y						
		iny									
		sta		($20),y						
		ldy		$30							
		dex								 
		bpl		CharsetNextPixel						 
		lda		$20							
		sec									
		sbc		#$28							
		sta		$20							
		bcs		c6						
		dec		$21							
c6:
		dey									
		bpl		Loop3						
		rts									
// ------------------------------------------------------------------------------------- | 
CharTestPixelsX:
		.byte		$C0, $30,$0C, $03
ColorPixelBits:
        .byte       $55, $AA, $FF, $00
PixelBits:
        .byte       $3F, $CF,$F3, $FC
// ------------------------------------------------------------------------------------- | 
ClearPixel:
		ldy		#$03							
        .byte   $2c
SetPixelMulti1:
		ldy		#$00							
        .byte   $2c
SetPixelMulti2:
		ldy		#$01							
        .byte   $2c
SetPixelCol:
		ldy		#$02							
		sty		SetPixelCol1+1						 
		lda		aCurrentCharNo						
		jsr		CalculatePosInCharset						
		ldx		aCharEditPixelX						
SetPixelCol1:
		ldy		#$03							 
		lda		ColorPixelBits,y						
		and		CharTestPixelsX,x						
		sta		$30						
		ldy		aCharEditPixelY						
		lda		(aPointerCharset),y						
		and		PixelBits,x						
		ora		$30							
		sta		(aPointerCharset),y						
		rts									
// ------------------------------------------------------------------------------------- | 
FillEditCharCol1:
		lda		#$55							
		.byte	$2C							
FillEditCharCol2:
		lda		#$AA							
		.byte	$2C							 
FillEditCharCol3:
		lda		#$FF							
		.byte	$2C							 
ClearEditChar:
		lda		#$00							
		sta		FillWith+1						
		lda		aCurrentCharNo							
		jsr		CalculatePosInCharset						
		ldy		#$07							
FillWith:
		lda		#$00							
!Loop:
		sta		(aPointerCharset),y						
		dey									
		bpl		!Loop-						 
		rts									
// ------------------------------------------------------------------------------------- | 
CalculatePosInCharset:
		ldy		#$00							
		sty		aPointerCharsetH							 
		asl									
		rol		aPointerCharsetH							
		asl									 
		rol		aPointerCharsetH							
		asl									
		rol		aPointerCharsetH						
		sta		aPointerCharsetL							 
		lda		aPointerCharsetH							
		adc		#>aCharset							
		sta		aPointerCharsetH							
		rts									 
// ------------------------------------------------------------------------------------- | 
CharLeft:
		dec		aCurrentCharNo							
		rts								
// ------------------------------------------------------------------------------------- | 
CharRight:
		inc		aCurrentCharNo							
		rts									
// ------------------------------------------------------------------------------------- | 
CharUp:
		lda		aCurrentCharNo							
		sec									
		sbc		#$28							 
		bcc		c7						
		sta		aCurrentCharNo							
c7:
		rts								
// ------------------------------------------------------------------------------------- | 
CharDown:
		lda		aCurrentCharNo							
		clc									
		adc		#$28						
		bcs		c8						
		sta		aCurrentCharNo						
c8:
		rts									
// ------------------------------------------------------------------------------------- | 
SetCharNoDisplay:
		lda		aCurrentCharNo							
		pha									
		and		#$0F							
		tax									
		lda		HexDigits,x						
		sta		tCharEditCharNo+1						
		sta		tForgroundEditCharNo+1						
		sta		tBackgrounndEditCharNo+1						
		pla									
		lsr									
		lsr									
		lsr									 
		lsr									 
		tax									
		lda		HexDigits,x						
		sta		tCharEditCharNo						
		sta		tForgroundEditCharNo				
		sta		tBackgrounndEditCharNo						
		rts									
// ------------------------------------------------------------------------------------- | 
SpritesFlashing:
		dec		$2A							 
		bpl		c1						
		lda		#$03							
		sta		$2A							
		dec		IndexSpriteColor+1						
		bpl		c1						
		lda		#$0A							
		sta		IndexSpriteColor+1	
IndexSpriteColor:					
c1:
		ldx		#$09							
		lda		FlashingColors,x						
		sta		$D027															
		sta		$D028																	
		rts									
// ------------------------------------------------------------------------------------- | 
PrintText:
		stx		aLoadText+1						
		sty		aLoadText+2						
		lda		#$28							
		sta		$27							
ReadText:
		lda		$27						
		tay									
		asl									
		tax									
		lda		TextHelpPointers,x						
		adc		#$00							
		sta		$28							 
		lda		TextHelpPointers+1,x						
		adc		#$FE							
		sta		$29							
		lda		#$00							 
		sta		PReadSpSet+2						
aLoadText:
		lda		tEditorText,y						
		and		#$3F							
		asl									 
		asl									
		asl									
		rol		PReadSpSet+2						 
		adc		#$00							 
		sta		PReadSpSet+1						
		lda		PReadSpSet+2						
		adc		#$F0							
		sta		PReadSpSet+2						
		ldy		#$1B							
		ldx		#$07							 
Loop4:
PReadSpSet:
		lda		$FF00,x						
		sta		($28),y						
		dey									
		dey									 
		dey									
		dex									
		bpl		Loop4						
		dec		$27							 
		bpl		ReadText					
		rts									 
// ------------------------------------------------------------------------------------- | 
tLoad:	
		.text "LOAD"
tSave:	
		.text "SAVE"
tFileprompt:
		.byte $22,$20,$20,$20,$20,$22,$20
		.text "FILEMAME:     "
tFilepromptEnter:
		.text "-->                  "	
Filename:
		.text "                 "
FilenameIndex:
        .byte $00
FileNumber:
        .byte $00
FileBegins:	
		.word $2000,$C800,$C400
FileEnds:	
		.word $44C0,$D000,$C600
LevelFilenamePrefix:
		.text "LV> "
		.text "CH> "
		.text "CO> "

tLoadErrorLine1:
		.text "-disk error-"
tLoadErrorLine2:
		.text "1) try again"
tLoadErrorLine3:
		.text "2) next file"
tLoadErrorLine4:
		.text "q) abort    "

FilenameDir:
		.text "$"

// ------------------------------------------------------------------------------------- | 
LoadLevel:
		ldy		#$03							 
!Loop:
		lda		tLoad,y						
		sta		tFileprompt+1,y						
		dey									
		bpl		!Loop-						
		jsr		PromptFilename						 
		pla									
		pla									
		jsr		SetSystemDefaults						
		lda		#$02							
		sta		FileNumber						
!NextFile:
		lda		#$08							 
		tax									 
		tay									
		jsr		$FFBA   //Set file parameters. Input: A = Logical number; X = Device number; Y = Secondary address.					
		lda		#$04							
		clc									
		adc		FilenameIndex						
		ldx		#<Filename					
		ldy		#>Filename							
		jsr		$FFBD	//Set filename parameters Input: A = File name length; X/Y = Pointer to file name						
		lda		FileNumber						
		asl									
		tax									 
		pha									
		asl									
		tay									
		ldx		#$00							
!Loop:
		lda		LevelFilenamePrefix,y						
		sta		Filename,x						 
		iny									 
		inx									 
		cpx		#$03							
		bne		!Loop-						
		lda		#$1D							
		jsr		$FFD2		//Write byte to output					
		pla									
		tax									
		ldy		FileBegins+1,x						
		lda		FileBegins,x						
		tax									
		jsr		$FFD5   //Load or verify file. (Must call SETLFS and SETNAM beforehands.) Input: A: 0 = Load, 1-255 = Verify; X/Y = Load address (if secondary address = 0). Output: Carry: 0 = No errors, 1 = Error; A = KERNAL error code (if Carry = 1); X/Y = Address of last byte loaded/verified (if Carry = 0).
		bcs		LoadError						
ContinueNextFile:
		dec		FileNumber						
		bpl		!NextFile-						
		jmp		ResumeEditor						
// ------------------------------------------------------------------------------------- | 
LoadError:
		jsr		LoadErrorScreen						
		cmp		#$00						
		beq		AbortLoadError						
		ldy		#$02							
		sty		$D011							
		cmp		#$01							
		beq		!NextFile-						
		cmp		#$02							
		beq		ContinueNextFile						
AbortLoadError:
		pla									
		pla									
		jmp		ResumeEditor						
// ------------------------------------------------------------------------------------- | 
SaveLevel:
		ldy		#$03							
!Loop:
		lda		tSave,y						 
		sta		tFileprompt+1,y						
		dey									
		bpl		!Loop-	
		jsr		PromptFilename						
		pla									
		pla									
		jsr		SetSystemDefaults					 
		lda		#$02							 
		sta		FileNumber						 
Nextfile:
		lda		#$08							
		tax									
		tay									
		jsr		$FFBA   //Set file parameters. Input: A = Logical number; X = Device number; Y = Secondary address.							
		lda		#$04							 
		clc									
		adc		FilenameIndex						
		ldx		#<Filename						 
		ldy		#>Filename				
		jsr		$FFBD	//Set filename parameters Input: A = File name length; X/Y = Pointer to file name 
		lda		FileNumber					
		asl									
		tax									
		pha									
		asl									 
		tay									
		ldx		#$00							
!NextCharPrefix:
		lda		LevelFilenamePrefix,y						 
		sta		Filename,x						
		iny									 
		inx									 
		cpx		#$03							
		bne		!NextCharPrefix-						
		lda		#$1D							
		jsr		$FFD2	//Write byte to output											
		pla									
		tax									
		lda		FileBegins,x						
		sta		$B4							
		lda		FileBegins+1,x						
		sta		$B5							
		ldy		FileEnds+1,x						 
		lda		FileEnds,x						 
		tax									
		lda		#$B4							
		jsr		$FFD8	//Save file. Input: A = Address of zero page register holding start address of memory area to save; X/Y = End address of memory area plus 1. Output: Carry: 0 = No errors, 1 = Error; A = KERNAL error code (if Carry = 1).					
		dec		FileNumber 
		bpl		Nextfile						
		jmp		ResumeEditor
// ------------------------------------------------------------------------------------- | 
LoadErrorScreen:
		lda		#$0D							
		sta		$D018							
		lda		#$00						
		sta		$D021							
		lda		#$C8						
		sta		$D016						
		jsr		ClearEditorScreen						
		ldy		#$0B							 
!Loop:
		lda		tLoadErrorLine1,y					
		sta		aScreen + $0B,y						
		lda		tLoadErrorLine2,y					
		sta		aScreen +$5B,y						
		lda		tLoadErrorLine3,y						
		sta		aScreen +$AB,y					
		lda		tLoadErrorLine4,y						
		sta		aScreen +$FB,y					
		lda		#$0A							
		sta		$D80B,y						
		sta		$D85B,y						 
		sta		$D8AB,y						
		sta		$D8FB,y						
		lda		#$0B							
		sta		$D818,y						
		sta		$D81C,y						
		lda		Filename+4,y						
		and		#$3F							
		sta		aScreen + $1C,y						
		dey									
		bpl		!Loop-						
		lda		FileNumber						
		asl									
		asl								
		tay									
		ldx		#$00							
!Loop:
		lda		LevelFilenamePrefix,y						
		and		#$3F							
		sta		$C018,x						
		iny									
		inx									
		cpx		#$04							
		bne		!Loop-						
		lda		#$1B							
		sta		$D011							
Loop5:
		lda		$DC01						
		cmp		#$BF							
		beq		c9						
		cmp		#$FE							
		beq		c10						
		cmp		#$F7							 
		beq		c11						
		jmp		Loop5						
c9:
		lda		#$00							
		.byte	$2C							 
c10:
		lda		#$01							 
		.byte	$2C							
c11:
		lda		#$02							
		rts	

//----------------------------------------------------------------------------------------								
PromptFilename:
		ldy		#$0B							
		lda		#$20							
Loop6:
		sta		Filename+4,y						
		dey									
		bpl		Loop6						
		lda		#$00							
		sta		FilenameIndex						
NextInput:
		ldy		#$0B							
NextLetterOFilename:
		lda		Filename+4,y						
		sta		tFilepromptEnter+3,y						
		dey									
		bpl		NextLetterOFilename						
		ldx		#<tFileprompt							
		ldy		#>tFileprompt							 
		jsr		PrintText						 
		lda		#$00							
		sta		aTmpKey						 
PfWaitForKey:
		lda		aTmpKey							
		beq		PfWaitForKey						
		cmp		#$0D							 
		beq		Endsub						
		cmp		#$03							
		beq		PlaPlaRts						
		cmp		#$14							
		beq		PrDelete						
		cmp		#$5A							
		bcs		PfWaitForKey						 
		cmp		#$20							 
		bcc		PfWaitForKey						
		ldy		FilenameIndex						
		cpy		#$0C							
		beq		PfWaitForKey						
		sta		Filename+4,y						
		inc		FilenameIndex						
		jmp		NextInput						 
PrDelete:
		ldy		FilenameIndex						 
		beq		c12						 
		dec		FilenameIndex						 
		dey									
c12:
		lda		#$20							
		sta		Filename+4,y						
		jmp		NextInput						
Endsub:
		rts									
// ------------------------------------------------------------------------------------- | 
PlaPlaRts:
		pla									 
		pla									
		rts									
// ------------------------------------------------------------------------------------- | 
SetSystemDefaults:
		lda		#$00							 
		sta		$D011							
SetSystemDefaults2:
		sei									
		lda		#$37							
		sta		$01							
		lda		#$31							 
		sta		$0314							
		lda		#$EA							
		sta		$0315							
		lda		#$7F							
		sta		$DC0D							
		sta		$DD0D							
		lda		#$08							
		sta		$DC0E							
		sta		$DD0E							
		sta		$DC0F							
		sta		$DD0F							
		lda		#$F0							 
		sta		$D01A							
		lda		#$79							
		sta		$D019							
		lda		#$00							
		sta		$D015							
		cli									
		rts									
// ------------------------------------------------------------------------------------- | 
ShowDirectory:
		jsr		SetSystemDefaults2						
		jsr		$E544		//Clear the screen						 
		lda		#$97							 
		sta		$DD00							 
		lda		#$15							
		sta		$D018							 
		lda		#$C8							
		sta		$D016							 
		lda		#$1B						
		sta		$D011							
		lda		#$00							
		sta		$D021							
		ldx		#$00							
		lda		#$03							
!Loop:
		sta		$D800,x					
		sta		$D900,x					 
		sta		$DA00,x						 
		sta		$DB00,x						
		inx								
		bne		!Loop-						
		lda		#$01	
		ldx		#<FilenameDir						
		ldy		#>FilenameDir					 					 
		jsr		$FFBD	//Set filename parameters Input: A = File name length; X/Y = Pointer to file name  
		lda		#$01							
		ldx		#$08						
		ldy		#$00						
		jsr		$FFBA   //Set file parameters. Input: A = Logical number; X = Device number; Y = Secondary address.					 
		jsr		$FFC0	//OPEN. Open file.					
		ldx		#$01							
		jsr		$FFC6	//Define file as default input.						 
		ldy		#$05						
!ContinueRead:
		sty		aTmpReadDir							
		jsr		$FFCF	//Read byte from default input (for keyboard, read a line from the screen). (If not keyboard, must call OPEN and CHKIN beforehands.)						
		tax									
		ldy		aTmpReadDir							
		dey									
		bne		!ContinueRead-						
		jsr		$FFCF	//Read byte from default input (for keyboard, read a line from the screen). (If not keyboard, must call OPEN and CHKIN beforehands.)						
		ldy		$90						
		bne		!Close+						
		jsr		$BDCD							
		lda		#$20							
		jsr		$FFD2		//Write byte to output					
!Loop:
		jsr		$FFCF		//Read byte from default input (for keyboard, read a line from the screen). (If not keyboard, must call OPEN and CHKIN beforehands.)						
		sta		aTmpReadDir						
		beq		!OutputEnter+						
		lda		aTmpReadDir						
		jsr		$FFD2		//Write byte to output						
		jmp		!Loop-						
// ------------------------------------------------------------------------------------- | 
!OutputEnter:
		lda		#$0D							
		jsr		$FFD2		//Write byte to output						
		ldy		#$03							 
		jmp		!ContinueRead-						
// ------------------------------------------------------------------------------------- | 
!Close:
		jsr		$FFCC	// Close default input/output files (for serial bus, send UNTALK and/or UNLISTEN); restore default input/output to keyboard/screen.							
		lda		#$01							
		jsr		$FFC3	// Close file.						
{WaitForSpace:
		lda		$DC01							
		cmp		#$EF							
		bne		WaitForSpace }						 
		pla									
		pla									
		jmp		ResumeEditor						
// ------------------------------------------------------------------------------------- | 
		
		

YposLetterSprites:
		.byte $00
LetterSpritePointers:
        .byte       $F8, $F9, $FA, $FB, $FC,$FD, $FE
LetterSpriteXPositions:    
		.byte       $0C, $24, $3C, $54, $6C, $84,$9C

TextHelpPointers:
		.word		$0000, $0001, $0002,$0040,$0041, $0042, $0080,$0081	
		.word		$0082, $00C0, $00C1,$00C2,$0100, $0101, $0102,$0140	
		.word		$0141, $0142, $0180,$0181,$0182, $0024, $0025,$0026	
		.word		$0064, $0065, $0066,$00A4,$00A5, $00A6, $00E4,$00E5		
		.word		$00E6, $0124, $0125,$0126,$0164, $0165, $0166,$01A4	
		.word		$01A5, $01A6

FlashingColors:
        .byte       $0B, $09, $02,$08, $0A, $07, $01, $07, $0A, $08, $02,$09

HexDigits:
        .byte       $30, $31, $32, $33, $34, $35, $36,$37
		.byte		$38, $39, $41, $42, $43, $44, $45,$46
	
BackgroundStarts: 
		.word aLevelBackground,aLevelBackground+(1*220),aLevelBackground+(2*220) ,aLevelBackground+(3*220) ,aLevelBackground+(4*220)
		.word aLevelBackground+(5*220) ,aLevelBackground+(6*220) ,aLevelBackground+(7*220) ,aLevelBackground+(8*220) ,aLevelBackground+(9*220)          

ForegroundStarts:
		.word (0*400),(1*400),(2*400),(3*400),(4*400),(5*400),(6*400),(7*400),(8*400),(9*400),(10*400)
		.word (11*400),(12*400),(13*400),(14*400),(15*400),(16*400),(17*400),(18*400),(19*400)


DataSprite1:
        .byte       $00, $00, $00
		.byte		$00, $00, $00, $00, $00, $00, $00, $00
		.byte		$00, $00, $00, $00, $00, $00, $00, $00	
		.byte		$00, $00, $00, $00, $00, $00, $00, $00	
		.byte		$00, $00, $00, $00, $00, $00, $00, $00	
		.byte		$00, $00, $00, $00, $FF, $00, $00, $81	
		.byte		$00, $00, $81, $00, $00, $81, $00, $00	
		.byte		$81, $00, $00, $81, $00, $00, $81, $00	
		.byte		$00, $FF, $00, $00
DataSprite2:
    	.byte       $FF, $00, $00, $81
		.byte		$00, $00, $81, $00, $00, $81, $00, $00	
		.byte		$81, $00, $00, $81, $00, $00, $81, $00
		.byte		$00, $FF, $00, $00, $00, $00, $00, $00
		.byte		$00, $00, $00, $00, $00, $00, $00, $00
		.byte		$00, $00, $00, $00, $00, $00, $00, $00
		.byte		$00, $00, $00, $00, $00, $00, $00, $00
		.byte		$00, $00, $00, $00, $00, $00, $00, $00
		.byte		$00, $00, $00
//End sprite2
		.byte		$00, $00, $00, $00, $00	// $1EF0 - $1EF7
		.byte		$00, $00, $00, $00, $00, $00, $00, $00	// $1EF8 - $1EFF
		.byte		$7B, $8F, $F5, $1D, $85, $61, $3C, $B5	// $1F00 - $1F07
		.byte		$18, $BA, $F5, $35, $B0, $3C, $95, $08	// $1F08 - $1F0F
		.byte		$95, $D3, $7D, $45, $6F, $7B, $BA, $F5	// $1F10 - $1F17
		.byte		$1D, $85, $61, $3C, $9E, $18, $2D, $D1	// $1F18 - $1F1F
		.byte		$3C, $99, $18, $2C, $D1, $3C, $9B, $18	// $1F20 - $1F27
		.byte		$2F, $D1, $3C, $9D, $18, $2E, $D1, $3C	// $1F28 - $1F2F
		.byte		$9C, $18, $29, $D1, $3C, $92, $18, $28	// $1F30 - $1F37
		.byte		$D1, $3C, $9C, $18, $2B, $D1, $D9, $B5	// $1F38 - $1F3F
		.byte		$9D, $B5, $36, $68, $3C, $EA, $18, $98	// $1F40 - $1F47
		.byte		$49, $B9, $98, $49, $38, $95, $48, $BC	// $1F48 - $1F4F
		.byte		$69, $18, $95, $48, $3C, $4D, $18, $83	// $1F50 - $1F57
		.byte		$45, $F5, $5E, $95, $95, $95, $FF, $FF	// $1F58 - $1F5F
		.byte		$FF							// $1F60 - $1F60

ClearAllLevelData:
		//Clear char colors and bumpdata
		ldx		#$00							
ClearChrcolBump:
		lda		#$0F							
		sta		aCharcolors,x						
		lda		#$00							
		sta		aBumpdata,x						
		inx									
		bne		ClearChrcolBump
		//Clear character set						
		lda		#>aCharset							
		sta		ClearCharset+2 						 
		ldy		#$07							
		lda		#$00							 
ClearCharset:
		sta		aCharset,x						
		inx									
		bne		ClearCharset						
		inc		ClearCharset+2						
		dey									
		bpl		ClearCharset	
		//Clear Level					
		lda		#>aLevel							
		sta		ClearLevel+2						 
		ldy		#$25							 
		lda		#$00							
ClearLevel:
		sta		aLevel,x						
		inx									
		bne		ClearLevel						 
		inc		ClearLevel+2					
		dey									
		bpl		ClearLevel						
		lda		#$0B							
		sta		aUpperMultiCol1							
		lda		#$0C							
		sta		aUpperMultiCol2							 
		lda		#$0E							 
		sta		aUpperBackCol							
		lda		#$08							
		sta		aLowerMultiCol1							
		lda		#$09							
		sta		aLowerMultiCol2							
		lda		#$07							 
		sta		aLowerBackCol					 
		lda		#$09							 
		sta		$44BE							 
		rts							 
// ------------------------------------------------------------------------------------- | 
InitSystemvalues:
		jsr		$FDA3	//initaliase I/O devices						
		lda		#$7F							
		sta		$DC0D							
		bit		$DC0D							
		lda		$DD00							
		and		#$FC							
		sta		$DD00							
		lda		#$D8							
		sta		$D016							
		rts									
// ------------------------------------------------------------------------------------- | 






