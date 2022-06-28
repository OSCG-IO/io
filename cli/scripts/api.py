####################################################
#  Copyright 2020-2022  OSCG  All rights reserved. #
####################################################

from __future__ import print_function, division

import json, os, platform, subprocess, sys, time
from datetime import datetime, timedelta
from operator import itemgetter

isPy3 = False
if sys.version_info >= (3, 0):
    isPy3 = True

try:
    from colorama import init
    init()
except ImportError as e:
    pass

scripts_lib_path = os.path.join(os.path.dirname(__file__), 'lib')
this_platform_system = str(platform.system())
platform_lib_path = os.path.join(scripts_lib_path, this_platform_system)
if os.path.exists(platform_lib_path):
  if platform_lib_path not in sys.path:
    sys.path.append(platform_lib_path)

import util

python_exe = sys.executable
python_ver = platform.python_version()

class bcolors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'
    BACKGROUND = '\033[42m'

style_start = bcolors.BOLD
style_end = bcolors.ENDC
table_header_style = bcolors.BOLD + bcolors.BACKGROUND
error_start = bcolors.FAIL


def get_pip_ver():
  try:
    import pip
    return(pip.__version__)
  except ImportError as e:
    pass
  return("None")


def cli_unicode(p_str,p_encoding,errors="ignore"):
  return str(p_str)

try:
    test_unicode = unicode("test")
except NameError as e:
    unicode = cli_unicode


def check_output_wmic (p_cmds):
  out1 = subprocess.check_output(p_cmds)
  try:
    out2 = str(out1, 'utf-8')
  except:
    out2 = str(out1)
  out3 = out2.strip().split("\n")[1]
  return(out3)


def top(display=True, isJson=False):
  import psutil

  current_timestamp = int(time.mktime(datetime.utcnow().timetuple()))
  jsonDict = {}
  procs = []
  for p in psutil.process_iter():
    try:
      p = p.as_dict(attrs=
        ['pid', 'username', 'cpu_percent', 'memory_percent', 'cpu_times', 'name'])
    except (psutil.NoSuchProcess, IOError, OSError) as e:
      pass
    else:
      procs.append(p)

  if not display:
    return

  processes = sorted(procs, key=lambda p: p['cpu_percent'], reverse=True)

  network_usage = psutil.net_io_counters()
  jsonDict['kb_sent'] = network_usage.bytes_sent / 1024
  jsonDict['kb_recv'] = network_usage.bytes_recv / 1024

  cpu = psutil.cpu_times_percent(percpu=False)
  iowait = ""
  if util.get_platform() == "Linux":
    jsonDict['iowait'] = str(cpu.iowait)
    iowait = "," + str(cpu.iowait).rjust(5) + "%wa"

  jsonDict['current_timestamp'] = current_timestamp
  jsonDict['cpu_user'] = str(cpu.user)
  jsonDict['cpu_system'] = str(cpu.system)
  jsonDict['cpu_idle'] = str(cpu.idle)
  if not isJson:
    print("CPU(s):" + str(cpu.user).rjust(5) + "%us," + \
      str(cpu.system).rjust(5) + "%sy," + str(cpu.idle).rjust(5) + "%id" + iowait)

  disk = psutil.disk_io_counters(perdisk=False)
  read_kb = disk.read_bytes / 1024
  write_kb = disk.write_bytes / 1024
  jsonDict['kb_read']  = str(read_kb)
  jsonDict['kb_write']  = str(write_kb)
  if not isJson:
    print("DISK: kB_read " + str(read_kb) + ", kB_written " + str(write_kb))

  uptime = datetime.now() - datetime.fromtimestamp(psutil.boot_time())
  str_uptime = str(uptime).split('.')[0]
  line = ""
  if util.get_platform() == "Windows":
    uname_len = 13
  else:
    uname_len = 8
    av1, av2, av3 = os.getloadavg()
    str_loadavg = "%.2f %.2f %.2f  " % (av1, av2, av3)
    line = style_start + "Load average: " + style_end + str_loadavg
    jsonDict['load_avg']  = str(str_loadavg)
  line = line + style_start + "Uptime:" + style_end + " " + str_uptime
  jsonDict['uptime']  = str(str_uptime)
  if not isJson:
    print(line)

  i = 0
  my_pid = os.getpid()
  if not isJson:
    print("")
    print(style_start + "  PID " + "USER".ljust(uname_len) + "   %CPU %MEM      TIME+ COMMAND" + style_end)

  jsonList = []
  for pp in processes:
    if pp['pid'] == my_pid:
      continue
    i += 1
    if i > 10:
      break

    # TIME+ column shows process CPU cumulative time and it
    # is expressed as: "mm:ss.ms"

    ctime = timedelta(seconds=sum(pp['cpu_times']))
    ctime_mm = str(ctime.seconds // 60 % 60)
    ctime_ss = str(int(ctime.seconds % 60)).zfill(2)
    ctime_ms = str(ctime.microseconds)[:2].ljust(2, str(0))
    ctime = "{0}:{1}.{2}".format(ctime_mm, ctime_ss, ctime_ms)

    if util.get_platform() == "Windows":
      username = str(pp['username'])
      # shorten username by eliminating stuff before the backslash
      slash_pos = username.find('\\')
      if slash_pos > 0:
        username = username[(slash_pos + 1):]
      username = username[:uname_len]
    else:
      username = pp['username'][:uname_len]
    if isJson:
        pp['username'] = username
        pp['ctime'] = ctime
        pp['cpu_percent'] = float(pp['cpu_percent'])
        pp['memory_percent'] = float(round(pp['memory_percent'],1))
        jsonList.append(pp)
    else:
 
      print( str(pp['pid']).rjust(5) + " " + \
            username.ljust(uname_len) + " " + \
            str(pp['cpu_percent']).rjust(6) + " " + \
            str(round(pp['memory_percent'],1)).rjust(4) + " " + \
            str(ctime).rjust(10) + " " + \
            pp['name'] )
  if isJson:
      jsonDict['top'] = jsonList
      print ( json.dumps([jsonDict]) )
  else:
    print( "" )


def list(p_json, p_cat, p_comp, p_ver, p_port, p_status, p_kount):
  lst = " "
  if p_kount > 1:
    lst = ","
  if p_json:
    lst = lst + \
      '{"category": "' + p_cat.rstrip() + '",' + \
      ' "component": "' + p_comp.rstrip() + '",' + \
      ' "version": "' + p_ver.rstrip() + '",' + \
      ' "port": "' + p_port.rstrip() + '",' + \
      ' "status": "' + p_status.rstrip() + '"}'
    print(lst)
    return

  print (p_comp + "  " +  p_ver + "  " + p_port + "  " + p_status)


def status (p_json, p_comp, p_ver, p_state, p_port, p_kount):
  status = " "
  if p_kount > 1:
    status = ","
  if p_json:
    jsonStatus = {}
    jsonStatus['component'] = p_comp
    jsonStatus['version'] = p_ver
    jsonStatus['state'] = p_state
    if p_port!="" and int(p_port)>1:
      jsonStatus['port'] = p_port
    category = util.get_comp_category(p_comp)
    if category:
      jsonStatus['category'] = category
    elif p_comp.startswith == "pgdg":
      jsonStatus['category'] = 1
    print(status + json.dumps(jsonStatus))
    return

  app_ver = p_comp + "-" + p_ver
  app_ver = app_ver + (' ' * (35 - len(app_ver)))

  if p_state in ("Running", "Stopped") and int(p_port)>1:
    on_port = " on port " + p_port
  else:
    on_port = ""

  #print(app_ver + "(" + p_state + on_port + ")")
  print(p_comp + " " + p_state.lower() + on_port)



def info(p_json, p_home, p_repo, print_flag=True):
  import os

  p_user = util.get_user()
  p_is_admin = util.is_admin()
  pip_ver = get_pip_ver()
  os_arch = util.get_arch()

  this_os = ""
  this_uname = str(platform.system())[0:7]
  host_ip = util.get_host_ip()
  wmic_path = os.getenv("SYSTEMROOT", "") + os.sep + "System32" + os.sep + "wbem" + os.sep + "wmic"
  if ((this_uname == "MINGW64") or (this_uname == "Windows")):
    import psutil
    host_display = os.getenv('LOGONSERVER','') + '\\' + os.getenv('COMPUTERNAME')
    system_cpu_cores = os.getenv('NUMBER_OF_PROCESSORS','1')
    cpu_model = check_output_wmic([wmic_path, "cpu", "get", "name"])
    ## system_memory_in_gb ######################################
    m = psutil.virtual_memory().total
    mem_bytes = int(m)
    system_memory_in_kbytes = mem_bytes / 1024.0
    system_memory_in_gb = str(mem_bytes / (1024.0**3))
  else:
    host_display = util.get_host_short()

  ## Check the OS & Resources ########################################
  plat = util.get_os()
  glibcV = util.get_glibc_version()

  os_major_ver = ""
  if this_uname == "Darwin":
    mem_mb = util.get_mem_mb()
    system_memory_in_kbytes = mem_mb * 1024
    system_memory_in_gb = mem_mb / 1024.0
    system_cpu_cores = util.get_cpu_cores()
    cpu_model=util.getoutput("/usr/sbin/sysctl -n machdep.cpu.brand_string")
    prod_name = util.getoutput("sw_vers -productName")
    prod_version = util.getoutput("sw_vers -productVersion")
    this_os = prod_name + " " + prod_version
  elif this_uname == "Linux":
    mem_mb = util.get_mem_mb()
    system_memory_in_kbytes = mem_mb * 1024
    system_memory_in_gb = mem_mb / 1024.0
    system_cpu_cores = util.get_cpu_cores()
    cpu_model=util.getoutput("grep 'model name' /proc/cpuinfo | head -1 | cut -d':' -f2")
    os_major_ver = util.getoutput("cat /etc/os-release | grep VERSION_ID | cut -d= -f2 | tr -d '\"'")
    if cpu_model == "":
      cpu_model="ARM"
    if os.path.exists("/etc/redhat-release"):
      this_os = util.getoutput("cat /etc/redhat-release")
    elif os.path.exists("/etc/system-release"):
      this_os = util.getoutput("cat /etc/system-release")
    elif os.path.exists("/etc/lsb-release"):
      this_os = util.getoutput("cat /etc/lsb-release | grep DISTRIB_DESCRIPTION | cut -d= -f2 | tr -d '\"'")
    elif os.path.exists("/etc/os-release"):
      this_os = util.getoutput("cat /etc/os-release | grep PRETTY_NAME | cut -d= -f2 | tr -d '\"'")
  elif this_uname == "Windows":
    caption = check_output_wmic([wmic_path, "os", "get", "caption"])
    svcpack = check_output_wmic([wmic_path, "os", "get", "servicepackmajorversion"])
    if svcpack == "0":
      this_os = caption
    else:
      this_os = caption + ", SP " + svcpack

  round_mem = util.pretty_rounder(float(system_memory_in_gb), 1)
  mem = str(round_mem) + " GB"

  cores = str(system_cpu_cores)

  cpu = cpu_model.strip()
  cpu = cpu.replace("(R)", "")
  cpu = cpu.replace("(TM)", "")
  cpu = cpu.replace(" CPU ", " ")

  os = this_os.replace(" release ", " ")
  os = os.replace(" (Final)", "")
  os = os.replace(" (Core)", "")

  ver = util.get_version()
  [last_update_utc, last_update_local, unique_id] = util.read_hosts('localhost')
  if last_update_local:
    last_upd_dt = datetime.strptime(last_update_local, "%Y-%m-%d %H:%M:%S")
    time_diff = int(util.timedelta_total_seconds(datetime.now() - last_upd_dt))
    last_update_readable = util.get_readable_time_diff(str(time_diff), precision=2)

  versions_sql = util.get_versions_sql()
  perl_ver = util.get_perl_ver()
  [java_major_ver, java_ver] = util.get_java_ver()

  os_pkg_mgr = util.get_pkg_mgr()
  jvm_location = util.get_jvm_location()

  if p_json:
    infoJsonArray = []
    infoJson = {}
    infoJson['version'] = ver
    infoJson['home'] = p_home
    infoJson['user'] = p_user
    infoJson['host'] = host_display
    infoJson['host_short'] = util.get_host_short()
    infoJson['host_long'] = util.get_host()
    infoJson['host_ip'] = util.get_host_ip()
    infoJson['os'] = unicode(str(os),sys.getdefaultencoding(),errors='ignore').strip()
    infoJson['os_pkg_mgr'] = os_pkg_mgr
    infoJson['os_major_ver'] = os_major_ver
    infoJson['platform'] = unicode(str(plat),sys.getdefaultencoding(),errors='ignore').strip()
    infoJson['arch'] = os_arch
    infoJson['mem'] = round_mem
    infoJson['cores'] = system_cpu_cores
    infoJson['cpu'] = cpu
    infoJson['last_update_utc'] = last_update_utc
    if last_update_local:
      infoJson['last_update_readable'] = last_update_readable
    infoJson['unique_id'] = unique_id
    infoJson['repo'] = p_repo
    infoJson['versions_sql'] = versions_sql
    infoJson['system_memory_in_kb'] = system_memory_in_kbytes
    infoJson['python_ver'] = python_ver
    infoJson['python_exe'] = python_exe
    if pip_ver != 'None':
      infoJson['pip_ver'] = pip_ver
    infoJson['perl_ver'] = perl_ver
    infoJson['java_ver'] = java_ver
    infoJson['java_major_ver'] = java_major_ver
    infoJson['jvm_location'] = jvm_location
    infoJson['glibc_ver'] = glibcV
    infoJsonArray.append(infoJson)
    if print_flag:
      print(json.dumps(infoJsonArray, sort_keys=True, indent=2))
      return
    else:
      return infoJson

  if p_is_admin:
    admin_display = " (Admin)"
  else:
    admin_display = ""

  langs = "Python v" + python_ver
  if perl_ver > "":
    langs = langs + " | Perl v" + perl_ver
  if java_ver > "":
    langs = langs + " | Java v" + java_ver

  util.validate_distutils_click(False)

  if glibcV <= ' ':
    glibc_v_display = ''
  else:
    glibc_v_display = 'glibc-' + glibcV

  print(style_start + ("#" * 70) + style_end)
  print(style_start + "#           OSCG.IO: " + style_end + "v" + ver + "  " + p_home)
  print(style_start + "#       User & Host: " + style_end + p_user + admin_display + "  " + host_display)
  print(style_start + "#  Operating System: " + style_end + os.rstrip() + " " + glibc_v_display + "-" + os_arch)
  print(style_start + "#           Machine: " + style_end + mem + ", " + cores + " vCPU, " + cpu)
  print(style_start + "# Programming Langs: " + style_end + langs)

  default_repo = "https://oscg-io-download.s3.amazonaws.com/REPO"
  if p_repo != default_repo:
    print(style_start + "#          Repo URL: " + style_end + p_repo)

  if versions_sql == "versions.sql":
    pass
  else:
    print(style_start + "#      Versions SQL: " + style_end + versions_sql)

  if not last_update_local:
    last_update_local="None"

  print(style_start + "#       Last Update: " + style_end + str(last_update_local))
  print(style_start + ("#" * 70) + style_end)


def info_component(p_comp_dict, p_kount):
    if p_kount > 1:
        print(style_start + ("-" * 90) + style_end)

    print(style_start + "     Project: " + style_end + p_comp_dict['project'] + " (" + p_comp_dict['project_url'] + ")" )

    print(style_start + "   Component: " + style_end + p_comp_dict['component'] + " " + p_comp_dict['version'] + " (" + p_comp_dict['proj_description'] + ")")

    if p_comp_dict['port'] > 1:
        print(style_start + "        port: " + style_end + str(p_comp_dict['port']))

    if p_comp_dict['datadir'] > "":
        print(style_start + "     datadir: " + style_end + p_comp_dict['datadir'])

    if p_comp_dict['logdir']  > "":
        print(style_start + "      logdir: " + style_end + p_comp_dict['logdir'])

    if p_comp_dict['autostart'] == "on":
        print(style_start + "   autostart: " + style_end + p_comp_dict['autostart'])

    if p_comp_dict['svcname'] > "" and util.get_platform() == "Windows":
        print(style_start + "     svcname: " + style_end + p_comp_dict['svcname'])

    if p_comp_dict['svcuser'] > "" and util.get_platform() == "Linux":
        print(style_start + "     svcuser: " + style_end + p_comp_dict['svcuser'])

    if (('status' in p_comp_dict)  and ('up_time' in p_comp_dict)):
        print(style_start + "      status: " + style_end + p_comp_dict['status'] + \
              style_start + " for " + style_end + p_comp_dict['up_time'])
    else:
        if 'status' in p_comp_dict:
            print(style_start + "      status: " + style_end + p_comp_dict['status'])
        if 'up_time' in p_comp_dict:
            print(style_start + "    up since: " + style_end + p_comp_dict['up_time'])

    if 'data_size' in p_comp_dict:
        print(style_start + "   data size: " + style_end + p_comp_dict['data_size'])

    if 'connections' in p_comp_dict:
        print(style_start + " connections: " + style_end + p_comp_dict['connections'])

    print(style_start + "Release Date: " + style_end + p_comp_dict['release_date'] + \
          style_start + "  Stage: " + style_end + p_comp_dict['stage'])

    if p_comp_dict['platform'] > "":
      print(style_start + "Supported On: " + style_end + "[" + p_comp_dict['platform'] + "]")

    if p_comp_dict['pre_reqs'] > "":
      print(style_start + "   Pre Req's: " + style_end + p_comp_dict['pre_reqs'])

    print(style_start +   "     License: " + style_end + p_comp_dict['license'])

    is_installed = str(p_comp_dict['is_installed'])
    if str(is_installed) == "0":
       is_installed = "NO"

    print(style_start +   "   IsCurrent: " + style_end + str(p_comp_dict['is_current']) + \
          style_start +   "  IsInstalled: " + style_end + is_installed)

    if p_comp_dict['relnotes']:
        print (style_start + " Release Notes : " + style_end )
        print (p_comp_dict['relnotes'] )


def format_data_to_table(data,
                    keys,
                    header=None,
                    error_key=None,
                    error_msg_column=None,
                    sort_by_key=None,
                    sort_order_reverse=False):
    """Takes a list of dictionaries, formats the data, and returns
    the formatted data as a text table.

    Required Parameters:
        data - Data to process (list of dictionaries). (Type: List)
        keys - List of keys in the dictionary. (Type: List)

    Optional Parameters:
        header - The table header. (Type: List)
        sort_by_key - The key to sort by. (Type: String)
        sort_order_reverse - Default sort order is ascending, if
            True sort order will change to descending. (Type: Boolean)
    """
    # Sort the data if a sort key is specified (default sort order
    # is ascending)
    if sort_by_key:
        data = sorted(data,
                      key=itemgetter(sort_by_key),
                      reverse=sort_order_reverse)

    # If header is not empty, add header to data
    if header:
        # Get the length of each header and create a divider based
        # on that length
        header_divider = []
        for name in header:
            header_divider.append('-' * len(name))

        # Create a list of dictionary from the keys and the header and
        # insert it at the beginning of the list. Do the same for the
        # divider and insert below the header.
        #header_divider = dict(zip(keys, header_divider))
        #data.insert(0, header_divider)
        header = dict(zip(keys, header))
        data.insert(0, header)

    column_widths = []
    for key in keys:
        column_widths.append(max(len(str(column[key])) for column in data)+2)

    # Create a tuple pair of key and the associated column width for it
    key_width_pair = zip(keys, column_widths)
    key_length =  len(keys)

    str_format = ('%-*s ' * len(keys)).strip() + '\n'
    formatted_data = ''

    for element in data:
        data_to_format = []
        s=0
        key_width_pair = zip(keys, column_widths)
        # Create a tuple that will be used for the formatting in
        # width, value format
        for pair in key_width_pair:
            dataStr = str(element[pair[0]])
            spaces = " " * ((int(float(pair[1])) - len(dataStr))-2)
            if s<key_length-1:
                spaces = spaces + " |"

            if dataStr in header.values():
                if s==0:
                    dataStr = table_header_style + dataStr
                dataStr = dataStr + spaces
                if s==key_length-1:
                    dataStr = dataStr + style_end
                s=s+1
            elif (error_key and error_msg_column):
                if pair[0] in error_msg_column and element.get(error_key[0]) == error_key[1]:
                  dataStr = error_start + dataStr + style_end

            data_to_format.append(pair[1])
            data_to_format.append(dataStr)
        formatted_data += str_format % tuple(data_to_format)
    return formatted_data

