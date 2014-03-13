
OPEN "rrrgggbb.inc" FOR OUTPUT AS #1

PRINT #1, "Palette label near"

FOR i = 0 TO 255
        r = INT(SQR(INT(i / 32) / 7) * 7 * 9)
        g = INT(SQR((INT(i / 4) MOD 8) / 7) * 7 * 9)
        b = INT(SQR((i MOD 4) / 3) * 3 * 21)
        PRINT #1, "    db " + STR$(r) + "," + STR$(g) + "," + STR$(b) + " ; " + STR$(i)
        PRINT "    db " + STR$(r) + "," + STR$(g) + "," + STR$(b) + " ; " + STR$(i)
NEXT

CLOSE (1)

