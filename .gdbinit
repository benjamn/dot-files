# .gdbinit file for debugging Mozilla

# run when using the auto-solib-add trick
def prun
        tbreak main
        run
	set auto-solib-add 0
        cont
end

# run -mail, when using the auto-solib-add trick
def pmail
        tbreak main
        run -mail
	set auto-solib-add 0
        cont
end


# Define a "pu" command to display PRUnichar * strings (100 chars max)
# Also allows an optional argument for how many chars to print as long as
# it's less than 100.
def pu
  set $uni = $arg0
  if $argc == 2
    set $limit = $arg1
    if $limit > 100
      set $limit = 100
    end
  else
    set $limit = 100
  end
  # scratch array with space for 100 chars plus null terminator.  Make
  # sure to not use ' ' as the char so this copy/pastes well.
  set $scratch = "____________________________________________________________________________________________________"
  set $i = 0
  set $scratch_idx = 0
  while (*$uni && $i++ < $limit)
    if (*$uni < 0x80)
      set $scratch[$scratch_idx++] = *(char*)$uni++
    else
      if ($scratch_idx > 0)
	set $scratch[$scratch_idx] = '\0'
	print $scratch
	set $scratch_idx = 0
      end
      print /x *(short*)$uni++
    end
  end
  if ($scratch_idx > 0)
    set $scratch[$scratch_idx] = '\0'
    print $scratch
  end
end

# Define a "ps" command to display subclasses of nsAC?String.  Note that
# this assumes strings as of Gecko 1.9 (well, and probably a few
# releases before that as well); going back far enough will get you
# to string classes that this function doesn't work for.
def ps
  set $str = $arg0
  if (sizeof(*$str.mData) == 1 && ($str.mFlags & 1) != 0)
    print $str.mData
  else
    pu $str.mData $str.mLength
  end
end


# print derived rather than declared types
set print object on


## From Boris Zbarsky:

# Don't stop for the SIG32/33/etc crap that Flash triggers
handle SIG32 noprint nostop pass
handle SIG33 noprint nostop pass
handle SIGPIPE noprint nostop pass

def jsstack
   call DumpJSStack()
end

# arg should be an nsStaticAtomWrapper*
def satom
  p *((class nsStaticAtomWrapper*)$arg0)->mStaticAtom
end

# arg should be a JSObject*
def jsclass
  # Look in the class slot
  p *(JSClass*)($arg0->slots[2] & ~1)
end

# arg should be a JSObject* for a Function
def jsscript
  # Assume this is a Function object and look in the private slot
  set $fun = (JSFunction*)($arg0->slots[3] & ~1)
  # Is it interpreted?
  if ($fun->flags & 0x8000)
    p *$fun->u.i.script
  else
    p "native"
  end
end

def pdomi
  set variable $node = $arg0
  set variable $indent = $arg1
  set variable $i = 0
  set variable $nkids = $node->GetChildCount()
  
  while ($i++ < $indent)
    output ""
  end
  p $node

  set variable $indent++
  set variable $i = 0
  while ($i < $nkids)
    pdomi $node->GetChildAt($i++) $indent
  end
end

def pdom
  pdomi mStack[$arg0].mContent 0
end
